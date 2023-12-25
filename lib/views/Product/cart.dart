import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/controllers/cart_controller.dart';
import 'package:babyshophub/views/Product/checkout.dart';
import 'package:babyshophub/views/Product/product-details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController _cartController = CartController();
  List<Map<String, dynamic>> selectedProducts = [];

  List<Map<String, dynamic>> _categories = [];
  @override
  void initState() {
    super.initState();
    // Fetch categories when the widget initializes
    _fetchCategories();
  }

  Future<bool> isProductValid(String productId, int quantity) async {
    try {
      // Reference to the products collection in Firestore
      CollectionReference products =
          FirebaseFirestore.instance.collection('products');

      // Fetch the product document
      DocumentSnapshot productSnapshot = await products.doc(productId).get();

      //update
      if (productSnapshot.exists && productSnapshot['status'] != -1) {
        _cartController.addToCart(productId, quantity);
      }

      // Check if the product exists and its status is not -1
      return productSnapshot.exists && productSnapshot['status'] != -1;
    } catch (e) {
      print('Error checking product validity: $e');
      return false;
    }
  }

  String getCategoryNames(String catId) {
    for (Map<String, dynamic> category in _categories) {
      if (category['id'] == catId) {
        return category['name'];
      }
    }
    return 'Not Found';
  }

  Future<void> updateProductCartField(String productId, int quantity) async {
    try {
      // Reference to the products collection in Firestore
      CollectionReference products =
          FirebaseFirestore.instance.collection('products');

      // Fetch the product document
      DocumentSnapshot productSnapshot = await products.doc(productId).get();

      // Check if the product exists
      if (productSnapshot.exists) {
        // Update the 'cart' field with the new quantity
        await products.doc(productId).update({'cart': quantity});
        print('Product cart field updated successfully!');
      } else {
        print('Product not found in Firestore!');
      }
    } catch (e) {
      print('Error updating product cart field: $e');
    }
  }

  Future<void> _fetchCategories() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(categoriesCollection)
          .get();

      setState(() {
        _categories = querySnapshot.docs.map((doc) {
          return {"id": doc.id, "name": doc['name']};
        }).toList();
      });
      print("Categories are:");
      print(_categories);
    } catch (e) {
      print('Error fetching categories: $e');
      // Handle the error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _cartController.getCartData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          List<Map<String, dynamic>> cartData = snapshot.data ?? [];

          if (cartData.isEmpty) {
            return Center(
              child: Text('No items in the cart'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartData.length,
                  itemBuilder: (context, index) {
                    final productId = cartData[index]['productId'];
                    final quantity = cartData[index]['quantity'];

                    print("$productId and $quantity");
                    return FutureBuilder<bool>(
                      future: isProductValid(productId, quantity),
                      builder: (context, productSnapshot) {
                        if (productSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        final bool isProductValid =
                            productSnapshot.data ?? false;

                        // Check if the current item has a different cat_id_fk compared to the previous one
                        final bool showHeading = index == 0 ||
                            cartData[index]['cat_id_fk'] !=
                                cartData[index - 1]['cat_id_fk'];

                        selectedProducts.add({
                          "productId": cartData[index]['productId'],
                          "quantity": cartData[index]['quantity'],
                          "name": cartData[index]['name'],
                          "price": cartData[index]['price'],
                          "imageUrls": cartData[index]['imageUrls'],
                        });

                        return showHeading
                            ? Column(
                                children: [
                                  Text(
                                      '${getCategoryNames(cartData[index]['cat_id_fk'])}'),
                                  Dismissible(
                                    key: Key(productId),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      color: Colors.red,
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.only(right: 20),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onDismissed: (direction) async {
                                      // Show a confirmation dialog
                                      bool confirmDelete = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Confirm Delete'),
                                            content: Text(
                                                'Are you sure you want to remove this item from the cart?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(true),
                                                child: Text('Delete'),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      // Check if the user confirmed the deletion
                                      if (confirmDelete ?? false) {
                                        // Remove the product from the cart when confirmed
                                        _cartController
                                            .removeFromCart(productId);
                                        // Reload cart data after removing
                                        setState(() {});
                                      }
                                    },
                                    child: GestureDetector(
                                      onTap: () async {
                                        // Navigate to the ProductDetails screen when card is clicked
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => isProductValid
                                                ? ProductDetails(
                                                    productId: productId,
                                                  )
                                                : Container(),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        color:
                                            isProductValid ? null : Colors.red,
                                        child: ListTile(
                                          leading: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    cartData[index]
                                                        ['imageUrls']),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(cartData[index]['name']),
                                              Text(
                                                  'Price: \$${cartData[index]['price'].toString()}'),
                                            ],
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.remove),
                                                onPressed: () async {
                                                  // Decrement quantity
                                                  _cartController
                                                      .decrementQuantity(
                                                          productId);
                                                  // Update the product cart field in Firestore
                                                  await updateProductCartField(
                                                      productId, quantity - 1);
                                                  // Reload cart data after decrement
                                                  setState(() {});
                                                },
                                              ),
                                              Text('$quantity'),
                                              IconButton(
                                                icon: Icon(Icons.add),
                                                onPressed: () async {
                                                  // Increment quantity
                                                  _cartController
                                                      .incrementQuantity(
                                                          productId);
                                                  // Update the product cart field in Firestore
                                                  await updateProductCartField(
                                                      productId, quantity + 1);
                                                  // Reload cart data after increment
                                                  setState(() {});
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : Dismissible(
                                key: Key(productId),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 20),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                onDismissed: (direction) async {
                                  // Show a confirmation dialog
                                  bool confirmDelete = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Confirm Delete'),
                                        content: Text(
                                            'Are you sure you want to remove this item from the cart?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  // Check if the user confirmed the deletion
                                  if (confirmDelete ?? false) {
                                    // Remove the product from the cart when confirmed
                                    _cartController.removeFromCart(productId);
                                    // Reload cart data after removing
                                    setState(() {});
                                  }
                                },
                                child: GestureDetector(
                                  onTap: () async {
                                    // Navigate to the ProductDetails screen when card is clicked
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => isProductValid
                                            ? ProductDetails(
                                                productId: productId,
                                              )
                                            : Container(),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    color: isProductValid ? null : Colors.red,
                                    child: ListTile(
                                      leading: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                cartData[index]['imageUrls']),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(cartData[index]['name']),
                                          Text(
                                              'Price: \$${cartData[index]['price'].toString()}'),
                                        ],
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.remove),
                                            onPressed: () async {
                                              // Decrement quantity
                                              _cartController
                                                  .decrementQuantity(productId);
                                              // Update the product cart field in Firestore
                                              await updateProductCartField(
                                                  productId, quantity - 1);
                                              // Reload cart data after decrement
                                              setState(() {});
                                            },
                                          ),
                                          Text('$quantity'),
                                          IconButton(
                                            icon: Icon(Icons.add),
                                            onPressed: () async {
                                              // Increment quantity
                                              _cartController
                                                  .incrementQuantity(productId);
                                              // Update the product cart field in Firestore
                                              await updateProductCartField(
                                                  productId, quantity + 1);
                                              // Reload cart data after increment
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // print(selectedProducts);
                  // Navigate to the CheckoutScreen and pass selectedProducts
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(selectedProducts),
                    ),
                  );
                },
                child: Text('Checkout'),
              ),
            ],
          );
        },
      ),
    );
  }
}
