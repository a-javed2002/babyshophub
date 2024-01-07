import 'package:animate_do/animate_do.dart';
import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/controllers/cart_controller.dart';
import 'package:babyshophub/controllers/wishlist_controller.dart';
import 'package:babyshophub/views/Product/cart.dart';
import 'package:babyshophub/views/Product/product-details.dart';
import 'package:babyshophub/views/Product/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:babyshophub/views/common/user-scaffold.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoryPage extends StatefulWidget {
  final String? title;
  final String? image;
  final String? id;

  const CategoryPage({Key? key,required this.title,required this.image,required this.id})
      : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("id in cat page is ${widget.id}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Hero(
              tag: widget.id!,
              child: Material(
                child: Container(
                  height: 360,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        colors: [
                          Colors.black.withOpacity(.8),
                          Colors.black.withOpacity(.1),
                        ],
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios,
                                  color: Colors.white),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                // FadeInUp(
                                //   duration: Duration(milliseconds: 1200),
                                //   child: IconButton(
                                //     icon:
                                //         Icon(Icons.search, color: Colors.white),
                                //     onPressed: () {},
                                //   ),
                                // ),
                                FadeInUp(
                                  duration: Duration(milliseconds: 1200),
                                  child: IconButton(
                                    icon: Icon(Icons.favorite,
                                        color: Colors.white),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WishlistScreen()));
                                    },
                                  ),
                                ),
                                FadeInUp(
                                  duration: Duration(milliseconds: 1300),
                                  child: IconButton(
                                    icon: Icon(Icons.shopping_cart,
                                        color: Colors.white),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CartScreen()));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        FadeInUp(
                          duration: Duration(milliseconds: 1200),
                          child: Text(
                            widget.title!,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 40),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  FadeInUp(
                    duration: Duration(milliseconds: 1400),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "All Product",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "",
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(Icons.arrow_forward_ios,
                                size: 11, color: Colors.grey),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  FadeInUp(
                    duration: Duration(milliseconds: 1500),
                    child: makeProduct(id: widget.id!),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget makeProduct({required String id}) {
    print("making product of id ${widget.id}");
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection(productsCollection).snapshots(),
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
        List<Widget> productWidgets = [];

        if (products.isEmpty) {
          return Center(
            child: Text('No products found.'),
          );
        }
        CartController _controllerCart = CartController();
        WishlistController _controllerWishlist = WishlistController();
        bool productIsInCart = false;
        bool productIsInWishlist = false;

        void chk(id) async {
          productIsInCart = await _controllerCart.isProductInCart(id);
          productIsInWishlist =
              await _controllerWishlist.isProductInWishlist(id);
        }

        Future<void> addWishlist(String productId) async {
          bool temp;
          print("Adding Wishlist...");
          temp = await _controllerWishlist.addToWishlist(productId);
          setState(() {});
        }

        Future<void> removeWishlist(String productId) async {
          bool temp;
          print("Removing Wishlist...");
          temp = await _controllerWishlist.removeFromWishlist(productId);
          setState(() {});
        }

        void showToast(String message) {
          Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
          );
        }

        for (var product in products) {
          if (product['category_id_fk'] == id) {
            chk(product.id);
            print(productIsInWishlist);
            productWidgets.add(
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductDetails(
                              productId: product.id,
                            )),
                  );
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                        product['imageUrls'][0],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        colors: [
                          Colors.black.withOpacity(.8),
                          Colors.black.withOpacity(.1),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FadeInUp(
                          duration: Duration(milliseconds: 1400),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: productIsInWishlist
                                ? GestureDetector(
                                    onTap: () async {
                                      await removeWishlist(product.id);
                                      showToast('Removed from Wishlist');
                                    },
                                    child:
                                        Icon(Icons.favorite, color: Colors.red))
                                : GestureDetector(
                                    onTap: () async {
                                      await addWishlist(product.id);
                                      showToast('Added to Wishlist');
                                    },
                                    child: Icon(Icons.favorite_border,
                                        color: Colors.white)),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FadeInUp(
                                  duration: Duration(milliseconds: 1500),
                                  child: Text(product['name'],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ),
                                FadeInUp(
                                  duration: Duration(milliseconds: 1500),
                                  child: Text(product['price'].toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            FadeInUp(
                              duration: Duration(milliseconds: 2000),
                              child: Container(
                                width: 40,
                                height: 40,
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (await _controllerCart.addToCart(
                                          product.id, 1)) {
                                        showToast(
                                          productIsInCart
                                              ? 'Already In Cart'
                                              : 'Added to Cart',
                                        );
                                        setState(() {
                                          productIsInCart = true;
                                        });
                                      } else {
                                        showToast('Error Add To Cart');
                                      }
                                    },
                                    child: Icon(Icons.add_shopping_cart,
                                        size: 18, color: Colors.grey[700]),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        }

        if (productWidgets.isEmpty) {
          return Center(
            child: Text('No products found with the specified ID.'),
          );
        }

        return Column(
          children: productWidgets,
        );
      },
    );
  }
}
