import 'dart:async';

import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/controllers/cart_controller.dart';
import 'package:babyshophub/views/Orders/orders.dart';
import 'package:babyshophub/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedProducts;

  CheckoutScreen(this.selectedProducts);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CartController _cartController = CartController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

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
                  future: FirebaseFirestore.instance
                      .collection('products')
                      .doc(productId)
                      .get(),
                  builder: (context, productSnapshot) {
                    if (productSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (productSnapshot.hasError || !productSnapshot.hasData) {
                      return ListTile(
                        title: Text('Error loading product details'),
                      );
                    }

                    final productData =
                        productSnapshot.data!.data() as Map<String, dynamic>;

                    return ListTile(
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(productData['imageUrls']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(productData['name']),
                          Text('Price: \$${productData['price'].toString()}'),
                          Text(
                              'Quantity: ${productData['quantity'].toString()}'),
                        ],
                      ),
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
                  decoration: InputDecoration(
                    labelText: 'Name',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.person),
                      onPressed: () {},
                    ),
                  ),
                  enabled: true,
                ),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    print("clicked Address");
                    showAddressPopup();
                  },
                  child: TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.place),
                        onPressed: () {
                          print("clicked Address");
                          showAddressPopup();
                        },
                      ),
                    ),
                    enabled: false,
                  ),
                ),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    print("clicked Contact");
                    showContactPopup();
                  },
                  child: TextField(
                    controller: _contactController,
                    decoration: InputDecoration(
                      labelText: 'Contact',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.call),
                        onPressed: () {
                          print("clicked Contact");
                          showContactPopup();
                        },
                      ),
                    ),
                    enabled: false,
                  ),
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

  void showAddressPopup() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    dynamic userId = user?.uid;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection(userCollection)
              .doc(userId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return ListTile(
                title: Text('Error loading user data'),
              );
            }

            List<String> addresses = snapshot.data!['address'] != null
                ? List<String>.from(snapshot.data!['address'])
                : [];

            print("Addresses Are ${addresses.length}");

            return Container(
              child: ListView.builder(
                itemCount:
                    addresses.length + 1, // +1 for the "Add Address" item
                itemBuilder: (context, index) {
                  if (index < addresses.length) {
                    return ListTile(
                      title: Text(addresses[index]),
                      onTap: () {
                        setState(() {
                          _addressController.text = addresses[index];
                        });
                        Navigator.pop(context);
                      },
                    );
                  } else {
                    return ListTile(
                      title: Center(child: Text('Add Address')),
                      onTap: () {
                        Navigator.pop(context); // Optionally close the pop-up
                        showAddAddressDialog();
                      },
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  void showAddAddressDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Address'),
          content: TextField(
            controller: _addressController,
            decoration: InputDecoration(labelText: 'New Address'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Add the new address to Firestore
                await addAddressToFirestore(_addressController.text);
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> addAddressToFirestore(String newAddress) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    dynamic userId = user?.uid;
    try {
      await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(userId)
          .update({
        'address': FieldValue.arrayUnion([newAddress]),
      });
    } catch (e) {
      print('Error adding address to Firestore: $e');
    }
  }

  void showContactPopup() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    dynamic userId = user?.uid;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection(userCollection)
              .doc(userId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return ListTile(
                title: Text('Error loading user data'),
              );
            }

            List<String> contacts = snapshot.data!['contact'] != null
                ? List<String>.from(snapshot.data!['contact'])
                : [];

            print("Contacts Are ${contacts.length}");

            return Container(
              child: ListView.builder(
                itemCount: contacts.length + 1, // +1 for the "Add Address" item
                itemBuilder: (context, index) {
                  if (index < contacts.length) {
                    return ListTile(
                      title: Text(contacts[index]),
                      onTap: () {
                        setState(() {
                          _contactController.text = contacts[index];
                        });
                        Navigator.pop(context);
                      },
                    );
                  } else {
                    return ListTile(
                      title: Center(child: Text('Add Contacts')),
                      onTap: () {
                        Navigator.pop(context); // Optionally close the pop-up
                        showAddContactDialog();
                      },
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  void showAddContactDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Contact'),
          content: TextField(
            controller: _contactController,
            decoration: InputDecoration(labelText: 'New Contact'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Add the new address to Firestore
                await addContactToFirestore(_contactController.text);
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> addContactToFirestore(String contact) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    dynamic userId = user?.uid;
    try {
      await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(userId)
          .update({
        'contact': FieldValue.arrayUnion([contact]),
      });
    } catch (e) {
      print('Error adding contact to Firestore: $e');
    }
  }

  void submitOrder() async {
    try {
      final String name = _nameController.text.trim();
      final List<Map<String, dynamic>> orderItems = widget.selectedProducts;

      if (name.isNotEmpty && orderItems.isNotEmpty) {
        final FirebaseAuth _auth = FirebaseAuth.instance;
        final User? user = _auth.currentUser;
        dynamic userId = user?.uid;
        DocumentReference orderRef =
            await FirebaseFirestore.instance.collection(ordersCollection).add({
          'userId': userId,
          'name': name,
          'address': _addressController.text,
          'contact': _contactController.text,
          'orderItems': orderItems,
          'status': "pending",
          'timestamp': FieldValue.serverTimestamp(),
        });

        String orderId = orderRef.id;

        await updateUserDocument(orderId);

        _nameController.clear();
        _addressController.clear();
        _contactController.clear();
        _cartController.clearCart();

        Timer(Duration(seconds: 2), () {
          print("checking onBoarding Status");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyOrdersScreen()),
          );
        });

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
        final CollectionReference users =
            FirebaseFirestore.instance.collection('users');

        DocumentSnapshot userSnapshot = await users.doc(user.uid).get();
        List<String> userOrders = [];

        if (userSnapshot.exists) {
          userOrders = List<String>.from(userSnapshot['orders']);
        }

        userOrders.add(orderId);

        await users.doc(user.uid).update({'orders': userOrders});
      }
    } catch (e) {
      print('Error updating user document: $e');
    }
  }
}
