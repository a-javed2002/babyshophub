import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/controllers/cart_controller.dart';
import 'package:babyshophub/controllers/wishlist_controller.dart';
import 'package:babyshophub/views/Product/product-details.dart';
import 'package:babyshophub/views/home/components/checkbox.dart';
import 'package:babyshophub/views/home/components/dropdown.dart';
import 'package:babyshophub/views/home/components/radiobox.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AllProductScreen extends StatefulWidget {
  @override
  _AllProductScreenState createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  late TextEditingController _searchController;
  CartController _controllerCart = CartController();
  WishlistController _controllerWishlist = WishlistController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> _categories = [
    {"all": "all"}
  ];
  bool priceAscending = true;
  bool nameAscending = true;
  TextEditingController lowPriceController = TextEditingController(text: '0');
  TextEditingController highPriceController =
      TextEditingController(text: '1000000');
  String selectedcategory = 'all';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(categoriesCollection)
          .get();

      setState(() {
        // Add the custom category "All" with ID 0
        _categories = [
          {"id": "all", "name": "All"},
          ...querySnapshot.docs.map((doc) {
            return {"id": doc.id, "name": doc['name']};
          }).toList(),
        ];
      });
      // print("Categories are:");
      // print(_categories);
    } catch (e) {
      print('Error fetching categories: $e');
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar:
          AppBar(title: Text('Product List'), automaticallyImplyLeading: false),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius as needed
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _categories = _categories;
                      priceAscending = true;
                      nameAscending = true;
                      lowPriceController = TextEditingController(text: '0');
                      highPriceController =
                          TextEditingController(text: '1000000');
                      selectedcategory = 'all';
                    });
                  },
                  child: Text(
                    "Clear Filters",
                    style: TextStyle(color: whiteColor),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.filter_list,
                  color: mainColor,
                  size: 20,
                ),
                onPressed: () {
                  // Open the drawer using the scaffold key
                  _scaffoldKey.currentState!.openDrawer();
                },
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              style: TextStyle(color: Colors.black),
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                labelText: 'Search Products',
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _buildQueryStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(),
                  );
                }

                List<DocumentSnapshot> products = snapshot.data!.docs;

                return Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic> productData =
                          products[index].data() as Map<String, dynamic>;

                      // Fetch category name for the current product
                      Future<DocumentSnapshot> categoryFuture =
                          FirebaseFirestore.instance
                              .collection('categories')
                              .doc(productData['category_id_fk'])
                              .get();

                      return FutureBuilder<DocumentSnapshot>(
                        future: categoryFuture,
                        builder: (context, categorySnapshot) {
                          String categoryName = 'Unknown';

                          if (categorySnapshot.hasData &&
                              categorySnapshot.data!.data() != null) {
                            categoryName = ((categorySnapshot.data!.data()
                                    as Map<String, dynamic>)['name'] ??
                                'Unknown') as String;
                          }

                          return FutureBuilder<bool>(
                            future: _controllerWishlist
                                .isProductInWishlist(products[index].id),
                            builder: (context, wishlistSnapshot) {
                              bool isProductInWishlist =
                                  wishlistSnapshot.data ?? false;

                              return FutureBuilder<bool>(
                                future: _controllerCart
                                    .isProductInCart(products[index].id),
                                builder: (context, cartSnapshot) {
                                  bool isProductCart =
                                      cartSnapshot.data ?? false;

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductDetails(
                                            productId: products[index].id,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      elevation: 2.0,
                                      margin: EdgeInsets.all(8.0),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              productData['imageUrls'][0]),
                                        ),
                                        title: Text(productData['name']),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'Price: \$${productData['price']}'),
                                            Text('Category: $categoryName'),
                                          ],
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(Icons.add_shopping_cart,
                                              color: textColor),
                                          onPressed: () async {
                                            await _controllerCart.addToCart(
                                                products[index].id, 1);
                                            isProductCart
                                                ? showToast('Already In Cart')
                                                : showToast('Added to Cart');
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: mainColor,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.filter_list,
                          size: 50,
                          color: mainColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Filters',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SmoothDropdown(
                selectedValue: "",
                title: 'Category',
                items: _categories,
                onItemSelected: (selectedValue) {
                  // Handle the selected value in the parent widget
                  // print('Selected value in parent widget: $selectedValue');
                  Navigator.pop(context);
                  selectedcategory = selectedValue;
                  print("Selected category is $selectedcategory");
                  _buildQueryStream();
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: lowPriceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Low Price'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: highPriceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'High Price'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the drawer
                      _buildQueryStream();
                    },
                    child: Center(child: Text('Search')),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double
                        .infinity, // Set the width to fill the available space
                    color: mainColor,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: Text(
                        'Price',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors
                              .white, // Set text color to contrast with background
                        ),
                      ),
                    ),
                  ),
                  CustomRadioBoxBtn(
                    options: ['Low to High', 'High To Low'],
                    selectFirstOption: true,
                    onPressed: (selectedValue) {
                  Navigator.pop(context);
                      print('Selected option: $selectedValue');
                      // You can perform any action with the selected value here
                      if (selectedValue.toString().toLowerCase() ==
                          'low to high') {
                        priceAscending = true;
                      } else {
                        priceAscending = false;
                      }
                      _buildQueryStream();
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double
                        .infinity, // Set the width to fill the available space
                    color: mainColor,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: Text(
                        'Alphabetic Order',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors
                              .white, // Set text color to contrast with background
                        ),
                      ),
                    ),
                  ),
                  CustomRadioBoxBtn(
                    options: ['A-Z', 'Z-A'],
                    selectFirstOption: true,
                    onPressed: (selectedValue) {
                  Navigator.pop(context);
                      print('Selected option: $selectedValue');
                      if (selectedValue.toString().toLowerCase() == 'a-z') {
                        nameAscending = true;
                      } else {
                        nameAscending = false;
                      }
                      _buildQueryStream();
                      // You can perform any action with the selected value here
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<QuerySnapshot> _buildQueryStream() {
    try {
      print("Fetching Started");
      String searchTerm = _searchController.text.toLowerCase();
      CollectionReference productsRef =
          FirebaseFirestore.instance.collection('products');

      Query query = productsRef;

      // Apply search filter if the searchTerm is not empty
      if (searchTerm.isNotEmpty) {
        query = query
            .where('name', isGreaterThanOrEqualTo: searchTerm)
            .where('name', isLessThan: searchTerm + 'z');
      }

      // Apply category filter
      if (selectedcategory != 'all') {
        query = query.where('category_id_fk', isEqualTo: selectedcategory);
      }

      // Apply price range filter
      double lowPrice = double.parse(lowPriceController.text);
      double highPrice = double.parse(highPriceController.text);

      query = query.where('price',
          isGreaterThanOrEqualTo: lowPrice, isLessThanOrEqualTo: highPrice);

      // Apply sorting based on flags
      if (priceAscending) {
        query = query.orderBy('price');
      } else {
        query = query.orderBy('price', descending: true);
      }

      if (nameAscending) {
        query = query.orderBy('name');
      } else {
        query = query.orderBy('name', descending: true);
      }

      query.snapshots().listen((QuerySnapshot snapshot) {
        snapshot.docs.forEach((DocumentSnapshot document) {
          print('Document ID: ${document.id}');
          print('Data: ${document.data()}');
        });
      });

      setState(() {
        _categories = _categories;
        selectedcategory=selectedcategory;
        nameAscending=nameAscending;
        priceAscending=priceAscending;
        _searchController.text=_searchController.text;
      });

      return query.snapshots();
    } catch (e) {
      // Log the error to the console
      print('Error in query: $e');
      // Return an empty stream in case of an error
      return Stream.empty();
    }
  }

  void _onSearchChanged(String value) {
    setState(() {});
  }
}
