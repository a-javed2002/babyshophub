import 'package:animate_do/animate_do.dart';
import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/views/Product/category.dart';
import 'package:babyshophub/views/Product/product-details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:babyshophub/views/common/user-scaffold.dart';

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
      stream: FirebaseFirestore.instance
          .collection(categoriesCollection)
          .snapshots(),
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
            return Card(
              child: InkWell(
                onTap: () {
                  // Handle category tap
                  print("id is ${category.id}");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryPage(
                        title: category['name'],
                        image: category['imageUrl'],
                        id: category.id,
                      ),
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