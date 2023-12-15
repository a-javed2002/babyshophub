import 'package:babyshophub/controllers/cart_controller.dart';
import 'package:babyshophub/controllers/wishlist_controller.dart';
import 'package:babyshophub/views/Product/cart.dart';
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
  late CartController _controllerCart;
  late WishlistController _controllerWishlist;
  bool productIsInCart = false;

  @override
  void initState() {
    super.initState();
    productDetailsFuture = fetchProductDetails(widget.product.id);
    allCategoriesFuture = fetchAllCategories();
    _controllerCart = CartController();
    _controllerWishlist = WishlistController();
  }

  Future<Map<String, dynamic>> fetchProductDetails(String productId) async {
    final productSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();

    final categoryId = productSnapshot['category_id_fk'];
    final categoryName = await getCategoryName(categoryId);

    return {
      'productDetails': productSnapshot.data(),
      'categoryName': categoryName,
    };
  }

  Future<List<Map<String, dynamic>>> fetchAllCategories() async {
    final categoriesSnapshot =
        await FirebaseFirestore.instance.collection('categories').get();

    final categories =
        categoriesSnapshot.docs.map((doc) => doc.data()).toList();

    return categories;
  }

  Future<String> getCategoryName(String categoryId) async {
    final categorySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryId)
        .get();

    return categorySnapshot['name'];
  }

  Future<void> toggleWishlistStatus(String productId) async {
    if(productIsInCart){
      await _controllerWishlist.addToWishlist(productId);
    }
    else{
      await _controllerWishlist.removeFromWishlist(productId);
    }

    setState(() {
      // Toggle the wishlist status
      productIsInCart = !productIsInCart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return UserCustomScaffold(
      appBarTitle: "Product Details",
      body: FutureBuilder<Map<String, dynamic>>(
        future: productDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final productDetails = snapshot.data!['productDetails'];
          final categoryName = snapshot.data!['categoryName'];

          _controllerCart.isProductInCart(widget.product.id).then((value) {
            productIsInCart = value;
          });

          bool productIsInWishlist = false;
          _controllerWishlist
              .isProductInWishlist(widget.product.id)
              .then((value) {
            productIsInCart = value;
          });

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(productDetails['name']),
                Text('Price: \$${productDetails['price']}'),
                Text('Category: $categoryName'),
                productIsInCart
                    ? Text("Already In Cart")
                    : ElevatedButton(
                        onPressed: () async {
                          if (await _controllerCart.addToCart(
                              widget.product.id, 3)) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CartScreen()),
                            );
                          }
                        },
                        child: Text("ADD TO CART"),
                      ),
                const Divider(),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await toggleWishlistStatus(widget.product.id);
                        // You can add your logic here after the status is toggled
                      },
                      child: Image.asset(
                        productIsInWishlist
                            ? 'assets/images/heart_filled.jpg'
                            : 'assets/images/heart_empty.jpg',
                        width: 30,
                        height: 30,
                      ),
                    ),
                    SizedBox(height: 8), // Add some space between the images
                    Text(
                      productIsInWishlist
                          ? "Already In Wishlist"
                          : "Not In Wishlist",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
