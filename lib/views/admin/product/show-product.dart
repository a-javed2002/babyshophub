import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/views/common/admin-scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ShowProduct extends StatefulWidget {
  const ShowProduct({Key? key}) : super(key: key);

  @override
  _ShowProductState createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  late List<Map<String, dynamic>> _products;

  @override
  void initState() {
    super.initState();
    // Fetch and load products when the screen is initialized
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(productsCollection) // Adjust the collection name as needed
          .get();

      setState(() {
        _products = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print('Error loading products: $e');
      // Handle the error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminCustomScaffold(
      appBarTitle: "Manage Products",
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display a list of products
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return ListTile(
                    title: Text(product['name']),
                    subtitle: Text(product['description']),
                    leading: FutureBuilder<String>(
                      future: _getImageUrl(product['imageUrls']),
                      builder: (context, imageUrlSnapshot) {
                        if (imageUrlSnapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        if (imageUrlSnapshot.hasError) {
                          return Text('Error: ${imageUrlSnapshot.error}');
                        }

                        final imageUrl = imageUrlSnapshot.data ?? '';
                        return CircleAvatar(
                          backgroundImage: NetworkImage(imageUrl),
                          radius: 25,
                        );
                      },
                    ),
                    // You can add more information here like price, quantity, etc.
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Handle edit action
                            // Navigate to edit product screen or show a dialog
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Handle delete action
                            _showDeleteConfirmationDialog(product['id'], product['imageUrls']);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _getImageUrl(List<String> imageUrls) async {
    if (imageUrls.isNotEmpty) {
      return imageUrls[0];
    } else {
      // If no product image exists, return a default image or handle as needed
      return 'assets/images/default_product_image.jpg';
    }
  }

  Future<void> _showDeleteConfirmationDialog(String productId, List<String> imageUrls) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this product?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                _deleteProduct(productId, imageUrls);
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      // User confirmed deletion, proceed with _deleteProduct
      _deleteProduct(productId, imageUrls);
    }
  }

  Future<void> _deleteProduct(String productId, List<String> imageUrls) async {
    try {
      // Delete product images from Firebase Storage
      for (final imageUrl in imageUrls) {
        final storageReference =
            firebase_storage.FirebaseStorage.instance.refFromURL(imageUrl);
        await storageReference.delete();
      }

      // Delete the product document from Firestore
      await FirebaseFirestore.instance
          .collection(productsCollection) // Adjust the collection name as needed
          .doc(productId)
          .delete();

      // Reload products after deletion
      _loadProducts();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product and images deleted successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error deleting product and images: $e');
      // Handle the error as needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting product and images: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
