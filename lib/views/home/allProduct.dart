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

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Product List'),
      ),
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
                    setState(() {});
                  },
                  child: Text(
                    "Clear Filters",
                    style: TextStyle(color: whiteColor),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.filter_list, color: mainColor),
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
                    child: CircularProgressIndicator(),
                  );
                }

                List<DocumentSnapshot> products = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> productData =
                        products[index].data() as Map<String, dynamic>;

                    return FutureBuilder<bool>(
                      future: _controllerWishlist
                          .isProductInWishlist(products[index].id),
                      builder: (context, snapshot) {
                        bool isProductInWishlist = snapshot.data ?? false;

                        return FutureBuilder<bool>(
                          future: _controllerCart
                              .isProductInCart(products[index].id),
                          builder: (context, snapshot) {
                            bool isProductCart = snapshot.data ?? false;

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
                                    backgroundImage:
                                        NetworkImage(productData['imageUrls']),
                                  ),
                                  title: Text(productData['name']),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Price: \$${productData['price']}'),
                                      Text(
                                          'Quantity: ${productData['quantity']}'),
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      isProductInWishlist
                                          ? IconButton(
                                              icon: Icon(Icons.favorite,
                                                  color: Colors.red),
                                              onPressed: () async {
                                                await _controllerWishlist
                                                    .removeFromWishlist(
                                                        products[index].id);
                                                showToast(
                                                    'Removed from Wishlist');
                                                setState(() {});
                                              },
                                            )
                                          : IconButton(
                                              icon: Icon(Icons.favorite_border,
                                                  color: Colors.white),
                                              onPressed: () async {
                                                await _controllerWishlist
                                                    .addToWishlist(
                                                        products[index].id);
                                                showToast('Added to Wishlist');
                                                setState(() {});
                                              },
                                            ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      IconButton(
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
                                    ],
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
                title: 'Plant',
                items: ['ALL', 'Plant 1', 'Plant 2', 'Plant 3', 'Plant 4'],
                onItemSelected: (selectedValue) {
                  // Handle the selected value in the parent widget
                  print('Selected value in parent widget: $selectedValue');
                },
              ),
              SmoothDropdown(
                selectedValue: "",
                title: 'Sold To Party',
                items: ['Mutiple', 'Single', 'etc'],
                onItemSelected: (selectedValue) {
                  // Handle the selected value in the parent widget
                  print('Selected value in parent widget: $selectedValue');
                },
              ),
              SmoothDropdown(
                selectedValue: "",
                title: 'Group',
                items: ['ALL', 'Group 1', 'Group 2', 'Group 3', 'Group 4'],
                onItemSelected: (selectedValue) {
                  // Handle the selected value in the parent widget
                  print('Selected value in parent widget: $selectedValue');
                },
              ),
              SmoothDropdown(
                selectedValue: "",
                title: 'Sub Group',
                items: [
                  'ALL',
                  'Sub Group 1',
                  'Sub Group 2',
                  'Sub Group 3',
                  'Sub Group 4'
                ],
                onItemSelected: (selectedValue) {
                  // Handle the selected value in the parent widget
                  print('Selected value in parent widget: $selectedValue');
                },
              ),
              SmoothDropdown(
                selectedValue: "",
                title: 'Category',
                items: [
                  'ALL',
                  'category 1',
                  'category 2',
                  'category 3',
                  'category 4'
                ],
                onItemSelected: (selectedValue) {
                  // Handle the selected value in the parent widget
                  print('Selected value in parent widget: $selectedValue');
                },
              ),
              SizedBox(
                height: 10,
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 2.0,
                runSpacing: 2.0,
                children: [
                  Container(
                    width: double.infinity,
                    color: mainColor,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: Text(
                        'Material Type',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  CustomCheckBoxBtn(title: 'LAMINATION'),
                  CustomCheckBoxBtn(title: 'PLYWOOD'),
                  CustomCheckBoxBtn(title: 'CHEMICAL'),
                  CustomCheckBoxBtn(title: 'MTW'),
                  CustomCheckBoxBtn(title: 'VENEERED PANEL'),
                  CustomCheckBoxBtn(title: 'DOOR SKIN'),
                  CustomCheckBoxBtn(title: 'EDGE BANDING'),
                  CustomCheckBoxBtn(title: 'SOFTWOOD LUMBER'),
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
                        'Division',
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
                    options: ['Select All', 'Wood'],
                    selectFirstOption: true,
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
    String searchTerm = _searchController.text.toLowerCase();
    CollectionReference productsRef =
        FirebaseFirestore.instance.collection('products');

    if (searchTerm.isEmpty) {
      return productsRef.snapshots();
    } else {
      return productsRef
          .where('name', isGreaterThanOrEqualTo: searchTerm)
          .where('name', isLessThan: searchTerm + 'z')
          .snapshots();
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      // Trigger rebuild with the updated search term
    });
  }
}
