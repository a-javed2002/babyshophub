import 'package:babyshophub/controllers/wishlist_controller.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final WishlistController _controller = WishlistController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _controller.getWishlistData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading Wishlist data'),
            );
          } else {
            final cartData = snapshot.data ?? [];

            if (cartData.isEmpty) {
              return Center(
                child: Text('No items in the Wishlist'),
              );
            }

            return ListView.builder(
              itemCount: cartData.length,
              itemBuilder: (context, index) {
                final item = cartData[index];
                final productId = item['productId'];
                final timestamp = item['timestamp'];

                return ListTile(
                  title: Text('Product ID: $productId'),
                  subtitle: Text('Timestamp: $timestamp'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _removeItem(productId);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  _clearCart();
                },
                child: Text('Clear Wishlist'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _removeItem(String productId) async {
    bool success = await _controller.removeFromWishlist(productId);

    if (success) {
      // Reload the Wishlist data after removing an item
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Item removed from Wishlist'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error removing item from Wishlist'),
      ));
    }
  }

  Future<void> _clearCart() async {
    bool success = await _controller.clearWishlist();

    if (success) {
      // Reload the cart data after clearing the cart
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Wishlist cleared'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error clearing Wishlist'),
      ));
    }
  }
}