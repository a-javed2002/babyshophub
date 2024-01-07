import 'package:animate_do/animate_do.dart';
import 'package:babyshophub/consts/firestore_consts.dart';
import 'package:babyshophub/views/Product/Category-All.dart';
import 'package:babyshophub/views/Product/cart.dart';
import 'package:babyshophub/views/Product/category.dart';
import 'package:babyshophub/views/Product/product-details.dart';
import 'package:babyshophub/views/Product/wishlist.dart';
import 'package:babyshophub/views/admin/others/FAQs.dart';
import 'package:babyshophub/views/admin/others/payment-security.dart';
import 'package:babyshophub/views/admin/others/privacy-policy.dart';
import 'package:babyshophub/views/admin/others/returns-exchange.dart';
import 'package:babyshophub/views/admin/others/terms-conditions.dart';
import 'package:babyshophub/views/home/allProduct.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

Widget LandingPage({required context}) {
  final myImageItems = [
    Image.asset('assets/images/image01.webp'),
    Image.asset('assets/images/image02.png'),
    Image.asset('assets/images/image03.webp'),
    Image.asset('assets/images/image04.jpg'),
    Image.asset('assets/images/image05.webp'),
  ];

  final myImageItemsText = [
    'Returns And Exchange',
    'Terms And Condition',
    'Privacy And policy',
    'Payment Security',
    'FAQs'
  ];

  int myImageCurrentIndex = 0;

  Future<List<String>> fetchAllProductIds() async {
    QuerySnapshot orderSnapshot =
        await FirebaseFirestore.instance.collection('orders').get();

    Set<String> uniqueProductIds = Set<String>();

    for (QueryDocumentSnapshot order in orderSnapshot.docs) {
      List<dynamic> orderItems = order['orderItems'];
      for (var item in orderItems) {
        // Assuming each order item has a 'productId' field
        String productId = item['productId'];
        if (productId != null && productId.isNotEmpty) {
          print(productId);
          uniqueProductIds.add(productId);
        }
      }
    }

    return uniqueProductIds.toList();
  }

  Future<String> getCategoryName(String categoryId) async {
    final categorySnapshot = await FirebaseFirestore.instance
        .collection(categoriesCollection)
        .doc(categoryId)
        .get();

    return categorySnapshot['name'];
  }

  Future<Map<String, dynamic>> fetchProductDetails(String productId) async {
    print("Product id is $productId");
    final productSnapshot = await FirebaseFirestore.instance
        .collection(productsCollection)
        .doc(productId)
        .get();

    final categoryId = productSnapshot['category_id_fk'];
    final categoryName = await getCategoryName(categoryId);

    return {
      'productDetails': productSnapshot.data(),
      'categoryName': categoryName,
    };
  }

  return SingleChildScrollView(
    child: Column(
      children: <Widget>[
        FadeInUp(
            duration: Duration(milliseconds: 1000),
            child: Container(
              height: 500,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background.jpg'),
                      fit: BoxFit.fill)),
              child: Container(
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(begin: Alignment.bottomRight, colors: [
                  Colors.black.withOpacity(.8),
                  Colors.black.withOpacity(.2),
                ])),
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FadeInUp(
                              duration: Duration(milliseconds: 1200),
                              child: IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              WishlistScreen()));
                                },
                              )),
                          FadeInUp(
                              duration: Duration(milliseconds: 1300),
                              child: IconButton(
                                icon: Icon(
                                  Icons.shopping_cart,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CartScreen()));
                                },
                              )),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FadeInUp(
                                duration: Duration(milliseconds: 1500),
                                child: Text(
                                  "Our Products",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                              height: 15,
                            ),
                            FadeInUp(
                                duration: Duration(milliseconds: 1700),
                                child: Row(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AllProductScreen()));
                                      },
                                      child: Text(
                                        "VIEW MORE",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                      size: 15,
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
        SizedBox(
          height: 10,
        ),
        CatTags(),
        Column(
          children: [
            GestureDetector(
              onTap: () {
                // Navigate to your desired screen when the carousel is tapped
                switch (myImageCurrentIndex) {
                  case 0:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReturnAndExchangeScreen()));
                    break;
                  case 1:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TermsAndConditionsScreen()));
                    break;
                  case 2:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PrivacyPolicyScreen()));
                    break;
                  case 3:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentSecurityScreen()));
                    break;
                  case 4:
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FaqScreen()));
                    break;
                }
              },
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  autoPlay: true,
                  height: 200,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayInterval: const Duration(seconds: 2),
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    myImageCurrentIndex = index;
                  },
                ),
                itemCount: myImageItems.length,
                itemBuilder: (context, index, realIndex) {
                  return SizedBox(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Set your desired width
                    height: 200, // Set your desired height
                    child: myImageItems[index], // Use the Image widget here
                  );
                },
              ),
            ),
            AnimatedSmoothIndicator(
              activeIndex: myImageCurrentIndex,
              count: myImageItems.length,
              effect: WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                spacing: 10,
                dotColor: Colors.grey.shade200,
                activeDotColor: Colors.grey.shade900,
                paintStyle: PaintingStyle.fill,
              ),
            )
          ],
        ),
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Top Selling",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Text("All")
                ],
              ),
              FutureBuilder<List<String>>(
                future: fetchAllProductIds(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }

                  if (snapshot.hasError) {
                    print('Error: ${snapshot.error}');
                    return Container();
                  }

                  List<String> productIds = snapshot.data!;

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: productIds.map((productId) {
                        return FutureBuilder<Map<String, dynamic>>(
                          future: fetchProductDetails(productId),
                          builder: (context, productSnapshot) {
                            if (productSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container();
                            }
                    
                            if (productSnapshot.hasError) {
                              return Text('Error: ${productSnapshot.error}');
                            }
                    
                            final productDetails =
                                productSnapshot.data!['productDetails'];
                            final categoryName =
                                productSnapshot.data!['categoryName'];
                    
                            return  Container(
                              height: 320,
                                child:
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductDetails(
                                            productId: productId,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 192, 109, 224),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.network(
                                                productDetails['imageUrls'][0],height: 250,),
                                            Text(
                                              productDetails['name'],
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              'Price: \$${productDetails['price']}',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
              // Add any additional widgets here if needed
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "New Arrivals",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  // Text("All")
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  List<QueryDocumentSnapshot> products = snapshot.data!.docs;

                  if (products.isEmpty) {
                    return Center(
                      child: Text('No products found.'),
                    );
                  }

                  // Set the limit for dynamic data
                  int dataLimit = 6;

                  // Only take the top products up to the data limit
                  List<QueryDocumentSnapshot> topProducts =
                      products.take(dataLimit).toList();

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      height: 320,
                      child: Row(
                        children: [
                          ...topProducts.map((product) {
                            return GestureDetector(
                              onTap: () {
                                // Navigate to the product detail page with product details
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetails(
                                      productId: product.id,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 192, 109, 224),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.network(product['imageUrls'][0]),
                                      Text(
                                        product['name'],
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Price: \$${product['price']}',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                          // Custom tag when length reaches the data limit
                          if (products.length > dataLimit)
                            Container(
                              height: 320,
                              child: GestureDetector(
                                onTap: () {
                                  // Navigate to the page showing all products
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AllProductScreen(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 48.0),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      // color: Color.fromARGB(255, 192, 109, 224),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'See All Products -->',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        // Container(
        //   padding: EdgeInsets.all(20),
        //   child: Column(
        //     children: <Widget>[
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: <Widget>[
        //           Text(
        //             "Best Selling",
        //             style: TextStyle(
        //                 color: Colors.black,
        //                 fontSize: 18,
        //                 fontWeight: FontWeight.bold),
        //           ),
        //           // Text("All")
        //         ],
        //       ),
        //       StreamBuilder<QuerySnapshot>(
        //         stream: FirebaseFirestore.instance
        //             .collection('products')
        //             .orderBy('timestamp',
        //                 descending: true) // Add orderBy for timestamp
        //             .limit(8) // Limit the results to 8
        //             .snapshots(),
        //         builder: (context, snapshot) {
        //           if (snapshot.connectionState == ConnectionState.waiting) {
        //             return Container();
        //           }

        //           if (snapshot.hasError) {
        //             return Text('Error: ${snapshot.error}');
        //           }

        //           List<QueryDocumentSnapshot> products = snapshot.data!.docs;

        //           return Column(
        //               children: products.map((product) {
        //             return Card(
        //               elevation: 2.0,
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(10),
        //               ),
        //               child: InkWell(
        //                 onTap: () {
        //                   Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                         builder: (context) =>
        //                             ProductDetails(productId: product.id)),
        //                   );
        //                 },
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.stretch,
        //                   children: [
        //                     ClipRRect(
        //                       borderRadius: BorderRadius.vertical(
        //                           top: Radius.circular(10)),
        //                       child: Image.network(
        //                         product['imageUrls'][
        //                             0], // Replace with the field in your Firestore document for image URL
        //                         height: 120,
        //                         fit: BoxFit.cover,
        //                       ),
        //                     ),
        //                     Padding(
        //                       padding: const EdgeInsets.all(8.0),
        //                       child: Column(
        //                         crossAxisAlignment: CrossAxisAlignment.start,
        //                         children: [
        //                           Text(
        //                             product[
        //                                 'name'], // Replace with the field in your Firestore document for product name
        //                             style: TextStyle(
        //                               fontSize: 16,
        //                               fontWeight: FontWeight.bold,
        //                               color: Colors.black
        //                             ),
        //                           ),
        //                           SizedBox(height: 4),
        //                           Text(
        //                             '\$${product['price'].toStringAsFixed(2)}', // Replace with the field in your Firestore document for product price
        //                             style: TextStyle(
        //                               fontSize: 14,
        //                               color: Colors.green,
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             );
        //           }).toList());
        //         },
        //       ),
        //     ],
        //   ),
        // ),
      ],
    ),
  );
}

class ProductCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        List<QueryDocumentSnapshot> products = snapshot.data!.docs;

        if (products.isEmpty) {
          return Center(
            child: Text('No products found.'),
          );
        }

        List<QueryDocumentSnapshot> topProducts = products.take(8).toList();

        print("Products are ${topProducts.length}");

        return OrientationBuilder(
          builder: (context, orientation) {
            int crossAxisCount = (orientation == Orientation.portrait) ? 2 : 3;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: topProducts.length,
              itemBuilder: (context, index) {
                var product = topProducts[index];

                return Card(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Handle product tap
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10)),
                          child: Image.network(
                            product['imageUrls'][0],
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '\$${product['price'].toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class CatTags extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        List<QueryDocumentSnapshot> categories = snapshot.data!.docs;

        if (categories.isEmpty) {
          return Center(
            child: Text('No categories found.'),
          );
        }

        // Set the limit for dynamic data
        int dataLimit = 6;

        // Only take the top categories up to the data limit
        List<QueryDocumentSnapshot> topCategories =
            categories.take(dataLimit).toList();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...topCategories.map((cat) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryPage(
                          id: cat.id,
                          title: cat['name'],
                          image: cat['imageUrl'],
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 192, 109, 224),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        cat['name'],
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }),
              // Custom tag when length reaches the data limit
              if (categories.length > dataLimit)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryShow(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 192, 109, 224),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'See All Categories',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
