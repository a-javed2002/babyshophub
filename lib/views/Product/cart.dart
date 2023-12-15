import 'package:babyshophub/controllers/cart_controller.dart';
import 'package:babyshophub/views/Product/checkout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController _cartController = CartController();
  List<Map<String, dynamic>> selectedProducts = [];

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

          if (cartData.isEmpty) {
            return Center(
              child: Text('No items in the cart'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartData.length,
                  itemBuilder: (context, index) {
                    final productId = cartData[index]['productId'];
                    final quantity = cartData[index]['quantity'];

                    return Card(
                      color: selectedProducts.any((element) => element['productId'] == productId)
                          ? Colors.yellow
                          : null,
                      child: ListTile(
                        title: Text(cartData[index]['name']),
                        subtitle: Text('Quantity: $quantity'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                // Decrement quantity
                                _cartController.decrementQuantity(productId);
                                // Reload cart data after decrement
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                // Increment quantity
                                _cartController.incrementQuantity(productId);
                                // Reload cart data after increment
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the CheckoutScreen and pass selectedProducts
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(selectedProducts),
                    ),
                  );
                },
                child: Text('Checkout'),
              ),
            ],
          );
        },
      ),
    );
  }
}
