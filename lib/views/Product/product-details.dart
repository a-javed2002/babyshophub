import 'package:babyshophub/views/common/user-scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  final QueryDocumentSnapshot product;

  ProductDetails({required this.product});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late Future<Map<String, dynamic>> productDetailsFuture;
  late Future<List<Map<String, dynamic>>> allCategoriesFuture;

  @override
  void initState() {
    super.initState();
    productDetailsFuture = fetchProductDetails(widget.product['productId']);
    allCategoriesFuture = fetchAllCategories();
  }

  Future<Map<String, dynamic>> fetchProductDetails(String productId) async {
    final productSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();

    final categoryId = productSnapshot['categoryId'];
    final categoryName = await getCategoryName(categoryId);

    return {
      'productDetails': productSnapshot.data(),
      'categoryName': categoryName,
    };
  }

  Future<List<Map<String, dynamic>>> fetchAllCategories() async {
    final categoriesSnapshot =
        await FirebaseFirestore.instance.collection('categories').get();

    final categories = categoriesSnapshot.docs.map((doc) => doc.data()).toList();

    return categories;
  }

  Future<String> getCategoryName(String categoryId) async {
    final categorySnapshot =
        await FirebaseFirestore.instance.collection('categories').doc(categoryId).get();

    return categorySnapshot['name'];
  }

  @override
  Widget build(BuildContext context) {
    return UserCustomScaffold(
      appBarTitle: "Product Details",
      body: FutureBuilder<Map<String, dynamic>>(
        future: productDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final productDetails = snapshot.data!['productDetails'];
          final categoryName = snapshot.data!['categoryName'];

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(productDetails['name']),
                Text('Price: \$${productDetails['price']}'),
                Text('Category: $categoryName'),
                // Add other product details here
              ],
            ),
          );
        },
      ),
    );
  }
}
