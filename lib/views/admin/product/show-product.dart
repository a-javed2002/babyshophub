import 'dart:math';

import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/views/admin/product/edit-product.dart';
import 'package:babyshophub/views/common/admin-scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class ShowProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdminCustomScaffold(
      context: context,
      appBarTitle: "Manage Products",
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(productsCollection).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No products found.'));
          }

          List<QueryDocumentSnapshot> products = snapshot.data!.docs;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index];
              return ListTile(
                title: Text("${product['name']} === ${product['timestamp']} === ${product['last_update_date']} === ${product['category_id_fk']}"),
                subtitle: Text("${product['description']} === ${product['price']} === ${product['quantity']} === ${product['status']}"),
                leading: FutureBuilder<String>(
                  future: _getImageUrl(product['imageUrls'][0]),
                  builder: (context, imageUrlSnapshot) {
                    if (imageUrlSnapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (imageUrlSnapshot.hasError) {
                      print('Error getting image URL: ${imageUrlSnapshot.error}');
                      return Text('Error loading image');
                    }

                    final imageUrl = imageUrlSnapshot.data ?? '';
                    return CircleAvatar(
                      backgroundImage: Image.network(
                        imageUrl,
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading image: $error');
                          return Text('Error loading image');
                        },
                      ).image,
                      radius: 25,
                    );
                  },
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProduct(productId: product.id,)),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Delete the category and associated images
                        _deleteCategory(context, product);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<String> _getImageUrl(dynamic imageUrlData) async {
    if (imageUrlData is List<String> && imageUrlData.isNotEmpty) {
      return imageUrlData[0];
    } else if (imageUrlData is String && imageUrlData.isNotEmpty) {
      return imageUrlData;
    } else {
      // If no category image exists, return a random image from assets
      final random = Random();
      final randomImageIndex = random.nextInt(3) + 1; // Assuming you have three random images in assets

      return 'assets/images/profile.jpg';
    }
  }

  Future<void> _deleteCategory(BuildContext context, QueryDocumentSnapshot category) async {
    bool confirmDelete = await _showDeleteConfirmationDialog(context);
    if (confirmDelete) {
      try {
        // Delete associated images from Firebase Storage
        await _deleteProductImages(category['imageUrls'][0]);
        
        // Delete the category from Firestore
        await FirebaseFirestore.instance.collection(productsCollection).doc(category.id).delete();
        
        print('Product deleted successfully');
      } catch (e) {
        print('Error deleting product: $e');
      }
    }
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog(
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
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProductImages(dynamic imageUrlData) async {
    try {
      if (imageUrlData is List<String>) {
        for (String imageUrl in imageUrlData) {
          await _deleteImage(imageUrl);
        }
      } else if (imageUrlData is String) {
        await _deleteImage(imageUrlData);
      }
    } catch (e) {
      print('Error deleting product images: $e');
    }
  }

  Future<void> _deleteImage(String imageUrl) async {
    try {
      final firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance.refFromURL(imageUrl);
      await storageReference.delete();
      print('Image deleted successfully: $imageUrl');
    } catch (e) {
      print('Error deleting image: $e');
    }
  }
}
