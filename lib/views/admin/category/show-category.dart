import 'dart:math';

import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/views/admin/category/edit-category.dart';
import 'package:babyshophub/views/common/admin-scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class ShowCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdminCustomScaffold(
      context: context,
      appBarTitle: "Manage Categories",
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(categoriesCollection)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No categories found.'));
          }

          List<QueryDocumentSnapshot> categories = snapshot.data!.docs;

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              var category = categories[index];
              return ListTile(
                title: Text(category['name']),
                subtitle: Text(category['description']),
                leading: FutureBuilder<String>(
                  future: _getImageUrl(category['imageUrl']),
                  builder: (context, imageUrlSnapshot) {
                    if (imageUrlSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (imageUrlSnapshot.hasError) {
                      print(
                          'Error getting image URL: ${imageUrlSnapshot.error}');
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
                        _editCategory(context, category);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Delete the category and associated images
                        _deleteCategory(context, category);
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
      final randomImageIndex = random.nextInt(3) +
          1; // Assuming you have three random images in assets

      return 'assets/images/profile.jpg';
    }
  }

  Future<void> _deleteCategory(
      BuildContext context, QueryDocumentSnapshot category) async {
    bool confirmDelete = await _showDeleteConfirmationDialog(context);
    if (confirmDelete) {
      try {
        // Delete associated images from Firebase Storage
        await _deleteCategoryImages(category['imageUrl']);

        // Delete the category from Firestore
        await FirebaseFirestore.instance
            .collection(categoriesCollection)
            .doc(category.id)
            .delete();

        print('Category deleted successfully');
      } catch (e) {
        print('Error deleting category: $e');
      }
    }
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this category?\nAll Related Products Will Get Inactive"),
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

  Future<void> _deleteCategoryImages(dynamic imageUrlData) async {
    try {
      if (imageUrlData is List<String>) {
        for (String imageUrl in imageUrlData) {
          await _deleteImage(imageUrl);
        }
      } else if (imageUrlData is String) {
        await _deleteImage(imageUrlData);
      }
    } catch (e) {
      print('Error deleting category images: $e');
    }
  }

  Future<void> _deleteImage(String imageUrl) async {
    try {
      final firebase_storage.Reference storageReference =
          firebase_storage.FirebaseStorage.instance.refFromURL(imageUrl);
      await storageReference.delete();
      print('Image deleted successfully: $imageUrl');
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  
  Future<void> _editCategory(BuildContext context, QueryDocumentSnapshot category) async {
    // Retrieve category data
    String categoryName = category['name'];
    String categoryDescription = category['description'];
    String categoryImageUrl = category['imageUrl'];

    // Show the edit category dialog
    bool result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditCategoryDialog(
          categoryId: category.id,
          categoryName: categoryName,
          categoryDescription: categoryDescription,
          categoryImageUrl: categoryImageUrl,
        );
      },
    );

    // Update Firestore if the user pressed "Save" in the dialog
    if (result == true) {
      print("updating to $categoryDescription");
      try {
        await FirebaseFirestore.instance
            .collection(categoriesCollection)
            .doc(category.id)
            .update({
          'name': categoryName,
          'description': categoryDescription,
          'imageUrl': categoryImageUrl,
          'last_update_date': FieldValue.serverTimestamp(),
        });
        
        print('Category updated successfully');
      } catch (e) {
        print('Error updating category: $e');
      }
    }
  }
}
