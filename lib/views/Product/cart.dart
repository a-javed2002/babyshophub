import 'package:babyshophub/controllers/cart_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  final CartController _cartController = CartController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _cartController.getCartData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          List<Map<String, dynamic>> cartData = snapshot.data ?? [];

          return ListView.builder(
            itemCount: cartData.length,
            itemBuilder: (context, index) {
              final productId = cartData[index]['productId'];
              final quantity = cartData[index]['quantity'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('products').doc(productId).get(),
                builder: (context, productSnapshot) {
                  if (productSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (productSnapshot.hasError || !productSnapshot.hasData) {
                    // Remove the product from the cart if it does not exist in Firestore
                    _cartController.removeFromCart(productId);
                    return Container();
                  }

                  final productData = productSnapshot.data!.data() as Map<String, dynamic>;

                  return ListTile(
                    title: Text(productData['name']),
                    subtitle: Text('Quantity: $quantity'),
                    // Add other product details as needed
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}