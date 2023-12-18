import 'package:babyshophub/controllers/wishlist_controller.dart';
import 'package:babyshophub/views/Product/product-details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final WishlistController _controller = WishlistController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist'),
      ),
      body: FutureBuilder<List<WishlistItem>>(
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
            final wishlistData = snapshot.data ?? [];

            if (wishlistData.isEmpty) {
              return Center(
                child: Text('No items in the Wishlist'),
              );
            }

            return ListView.builder(
              itemCount: wishlistData.length,
              itemBuilder: (context, index) {
                final item = wishlistData[index];
                final productId = item.productId;
                final timestamp = item.timestamp;

                return Dismissible(
                  key: Key(productId),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) async {
                            // Show a confirmation dialog
                            bool confirmDelete = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Delete'),
                                  content: Text(
                                      'Are you sure you want to remove this item from the cart?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );

                            // Check if the user confirmed the deletion
                            if (confirmDelete ?? false) {
                              // Remove the product from the cart when confirmed
                              _removeItem(productId);
                              // Reload cart data after removing
                              setState(() {});
                            }
                          },
                  child: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('products')
                        .doc(productId)
                        .get(),
                    builder: (context, productSnapshot) {
                      if (productSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (!productSnapshot.hasData ||
                          !productSnapshot.data!.exists) {
                        // Handle the case where the product does not exist
                        _removeItem(productId);
                        return Container();
                      }

                      final productData = productSnapshot.data!;
                      final productName = productData['name'];
                      // final productImageUrls = List<String>.from(
                      //     productData['imageUrls'] ?? []);

                      final bool isProductValid = productData['status']==1;

                      return GestureDetector(
                            onTap: () async {
                              // Navigate to the ProductDetails screen when card is clicked
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => isProductValid
                                      ? ProductDetails(
                                          productId: productId,
                                        )
                                      : Container(),
                                ),
                              );
                            },
                            child: Card(
                              color: isProductValid ? null : Colors.red,
                              child: ListTile(
                                leading: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          productData['imageUrls']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(productData['name']),
                                    Text(
                                        'Price: \$${productData['price'].toString()}'),
                                  ],
                                ),
                              ),
                            ),
                          );
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
                  _clearWishlist();
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

  Future<void> _clearWishlist() async {
    bool success = await _controller.clearWishlist();

    if (success) {
      // Reload the wishlist data after clearing the wishlist
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
