import 'package:babyshophub/views/Product/product-details.dart';
import 'package:babyshophub/views/common/user-scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductShow extends StatelessWidget {
  final String categoryId;

  ProductShow({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return UserCustomScaffold(
      appBarTitle: "Products in Category",
      body: ProductGrid(categoryId: categoryId),
    );
  }
}

class ProductGrid extends StatelessWidget {
  final String categoryId;

  ProductGrid({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('category_id_fk', isEqualTo: categoryId)
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

        List<QueryDocumentSnapshot> products = snapshot.data!.docs;

        if (products.isEmpty) {
          return Center(
            child: Text('No products found in this category.'),
          );
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            var product = products[index];
            return Card(
              child: InkWell(
                onTap: () {
                  // Handle product tap
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetails(product: product),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Add product-specific widgets here
                    Text(product['name']),
                    Text('Price: \$${product['price']}'),
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
