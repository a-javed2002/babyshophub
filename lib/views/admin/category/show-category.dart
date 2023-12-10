import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/views/common/admin-scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class ShowCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdminCustomScaffold(
      appBarTitle: "Manage Categories",
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(categoriesCollection).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No categories found.');
          }

          List<QueryDocumentSnapshot> categories = snapshot.data!.docs;

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              var category = categories[index];
              return ListTile(
                title: Text(category['name']),
                subtitle: Text(category['description']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Navigate to a screen for editing the category
                        // You can pass the category data to the editing screen
                        // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => EditCategoryScreen(category)));
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

  Future<void> _deleteCategory(BuildContext context, QueryDocumentSnapshot category) async {
    try {
      // Delete associated images from Firebase Storage
      await _deleteCategoryImages(category['imageUrl']);
      
      // Delete the category from Firestore
      await FirebaseFirestore.instance.collection(categoriesCollection).doc(category.id).delete();
      
      print('Category deleted successfully');
    } catch (e) {
      print('Error deleting category: $e');
    }
  }

  Future<void> _deleteCategoryImages(List<String> imageUrls) async {
    try {
      for (String imageUrl in imageUrls) {
        final firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance.refFromURL(imageUrl);
        await storageReference.delete();
      }
    } catch (e) {
      print('Error deleting category images: $e');
    }
  }
}
