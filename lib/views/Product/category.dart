import 'package:babyshophub/views/Product/product.dart';
import 'package:babyshophub/views/common/user-scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryShow extends StatelessWidget {
  const CategoryShow({Key? key});

  @override
  Widget build(BuildContext context) {
    return UserCustomScaffold(
      appBarTitle: "All Categories",
      body: CategoryGrid(),
    );
  }
}

class CategoryGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        List<QueryDocumentSnapshot> categories = snapshot.data!.docs;

        if (categories.isEmpty) {
          return Center(
            child: Text('No categories found.'),
          );
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            var category = categories[index];
            print(category.id);
            return Card(
              child: InkWell(
                onTap: () {
                  // Handle category tap
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductShow(categoryId: category.id),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Add category-specific widgets here
                    Text(category['name']),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
