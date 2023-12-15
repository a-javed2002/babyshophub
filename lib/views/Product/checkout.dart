import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedProducts;

  CheckoutScreen(this.selectedProducts);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.selectedProducts.length,
              itemBuilder: (context, index) {
                final productId = widget.selectedProducts[index]['productId'];
                final quantity = widget.selectedProducts[index]['quantity'];

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('products').doc(productId).get(),
                  builder: (context, productSnapshot) {
                    if (productSnapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (productSnapshot.hasError || !productSnapshot.hasData) {
                      return ListTile(
                        title: Text('Error loading product details'),
                      );
                    }

                    final productData = productSnapshot.data!.data() as Map<String, dynamic>;

                    return ListTile(
                      title: Text(productData['name']),
                      subtitle: Text('Quantity: $quantity'),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Your Name'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    submitOrder();
                  },
                  child: Text('Submit Order'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void submitOrder() async {
    try {
      final String name = _nameController.text.trim();
      final List<Map<String, dynamic>> orderItems = widget.selectedProducts;

      if (name.isNotEmpty && orderItems.isNotEmpty) {
        // Insert order details into Firestore
        DocumentReference orderRef = await FirebaseFirestore.instance.collection('ordersCollection').add({
          'name': name,
          'orderItems': orderItems,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Get the generated orderId
        String orderId = orderRef.id;

        // Update user's document with the orderId
        await updateUserDocument(orderId);

        // Clear the form and show a success message
        _nameController.clear();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Order submitted successfully!'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please enter your name and select products to order.'),
        ));
      }
    } catch (e) {
      print('Error submitting order: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error submitting order. Please try again.'),
      ));
    }
  }

  Future<void> updateUserDocument(String orderId) async {
    try {
      final User? user = _auth.currentUser;

      if (user != null) {
        final CollectionReference users = FirebaseFirestore.instance.collection('users');

        // Fetch existing user data
        DocumentSnapshot userSnapshot = await users.doc(user.uid).get();
        List<String> userOrders = [];

        if (userSnapshot.exists) {
          userOrders = List<String>.from(userSnapshot['orders']);
        }

        // Add the orderId to the user's orders array
        userOrders.add(orderId);

        // Update the user document in Firestore
        await users.doc(user.uid).update({'orders': userOrders});
      }
    } catch (e) {
      print('Error updating user document: $e');
    }
  }
}
