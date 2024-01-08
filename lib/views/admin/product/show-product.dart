import 'dart:math';

import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/views/admin/product/edit-product.dart';
import 'package:babyshophub/views/common/admin-scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class ShowProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdminCustomScaffold(
      context: context,
      bottom: true,
      cat: false,
      appBarTitle: "Manage Products",
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(productsCollection)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No products found.'));
          }

          List<QueryDocumentSnapshot> products = snapshot.data!.docs;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index];
              return ListTile(
                title: Text("${product['name']}"),
                subtitle: Column(
                  children: [
                    Text(
                        "Price \$${product['price']}"),
                    Text(
                        "Quantity \$${product['quantity']}"),
                  ],
                ),
                leading: FutureBuilder<String>(
                  future: _getImageUrl(product['imageUrls'][0]),
                  builder: (context, imageUrlSnapshot) {
                    if (imageUrlSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (imageUrlSnapshot.hasError) {
                      print(
                          'Error getting image URL: ${imageUrlSnapshot.error}');
                      return Text('Error loading image');
                    }

                    final imageUrl = imageUrlSnapshot.data ?? '';
                    return GestureDetector(
                      onTap: () {
                        print("opening Detail");
                        _showProductDetailsPopup(context, product);
                      },
                      child: CircleAvatar(
                        backgroundImage: Image.network(
                          imageUrl,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading image: $error');
                            return Text('Error loading image');
                          },
                        ).image,
                        radius: 25,
                      ),
                    );
                  },
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    product['status'] == '-1'
                        ? IconButton(
                            icon: Icon(Icons.restore),
                            onPressed: () async {
                              bool? confirmation =
                                  await _showConfirmationDialog(context,
                                      "Are sure you want to restore it?");
                              if (!confirmation) {
                                // User canceled the update
                                return;
                              }
                              try {
                                updateProductStatus(product.id, '1');
                              } catch (e) {
                                print("error restoring product $e");
                              }
                            },
                          )
                        : product['status'] == '1'
                            ? IconButton(
                                icon: Icon(Icons.visibility),
                                onPressed: () async {
                                  bool? confirmation =
                                      await _showConfirmationDialog(context,
                                          "Are sure you want to deactivate it?");
                                  if (!confirmation) {
                                    // User canceled the update
                                    return;
                                  }
                                  try {
                                    updateProductStatus(product.id, '0');
                                  } catch (e) {
                                    print("error deactivating product $e");
                                  }
                                },
                              )
                            : IconButton(
                                icon: Icon(Icons.visibility_off),
                                onPressed: () async {
                                  bool? confirmation =
                                      await _showConfirmationDialog(context,
                                          "Are sure you want to activate it?");
                                  if (!confirmation) {
                                    // User canceled the update
                                    return;
                                  }
                                  try {
                                    updateProductStatus(product.id, '1');
                                  } catch (e) {
                                    print("error restoring product $e");
                                  }
                                },
                              ),
                    product['status'] != '-1'?IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _editProduct(context, product);
                      },
                    ):Container(),
                    product['status'] != '-1'?IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        bool? confirmation = await _showConfirmationDialog(
                            context, "Are sure you want to delete it?");
                        if (!confirmation) {
                          // User canceled the update
                          return;
                        }
                        try {
                          updateProductStatus(product.id, '-1');
                          print("deleted ${product.id}");
                        } catch (e) {
                          print("error delete product $e");
                        }
                      },
                    ):Container(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showProductDetailsPopup(
      BuildContext context, QueryDocumentSnapshot product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Product Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                  product['imageUrls'][0]), // Display the image in the popup
              SizedBox(height: 10),
              Text(
                'Name: ${product['name']}',
                style: TextStyle(color: Colors.black),
              ),
              Text(
                'Category ID: ${product['category_id_fk']}',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                'Description: ${product['description']}',
                style: TextStyle(color: Colors.black),
              ),
              Text(
                'Price: ${product['price']}',
                style: TextStyle(color: Colors.black),
              ),
              Text(
                'Quantity: ${product['quantity']}',
                style: TextStyle(color: Colors.black),
              ),
              Text(
                'Status: ${product['status']}',
                style: TextStyle(color: Colors.black),
              ),
              Text(
                'Timestamp: ${(product['timestamp'] as Timestamp).toDate()}',
                style: TextStyle(color: Colors.black),
              ),
              Text(
                'Last Update Date: ${(product['last_update_date'] as Timestamp).toDate()}',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context, String msg) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Update'),
          content: Text('$msg',style: TextStyle(color: Colors.black),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User canceled the update
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed the update
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateProductStatus(String productId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection(productsCollection)
          .doc(productId)
          .update({
        'status': newStatus,
      });
      print('Product status updated successfully');
    } catch (e) {
      print('Error updating product status: $e');
      // Handle error as needed
    }
  }

  Future<void> _editProduct(
      BuildContext context, QueryDocumentSnapshot product) async {
    // Retrieve category data
    String productName = product['name'];
    String productStatus = product['status'].toString();
    String productPrice = product['price'].toString();
    String productQuantity = product['quantity'].toString();
    String productDescription = product['description'];
    List<dynamic> productImageUrl = product['imageUrls'];

    print("Sjowing edit page");

    // Show the edit category dialog
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditProductDialog(
          productId: product.id,
          productName: productName,
          productDescription: productDescription,
          productImageUrl: productImageUrl,
          productPrice: productPrice,
          productQuantity: productQuantity,
          productStatus: productStatus,
        );
      },
    );

    // Update Firestore if the user pressed "Save" in the dialog
    if (result['change'] =='1'){
      print("inside");
      print("updating to $productDescription");
      try {
        await FirebaseFirestore.instance
            .collection(productsCollection)
            .doc(product.id)
            .update({
          'name': result['name'],
          'description': result['description'],
          'price': result['price'],
          'quantity': result['quantity'],
          'last_update_date': FieldValue.serverTimestamp(),
        });

        print('Category updated successfully');
      } catch (e) {
        print('Error updating category: $e');
      }
    }
  }

  Future<String> _getImageUrl(dynamic imageUrlData) async {
    if (imageUrlData is List<String> && imageUrlData.isNotEmpty) {
      return imageUrlData[0];
    } else if (imageUrlData is String && imageUrlData.isNotEmpty) {
      return imageUrlData;
    } else {
      // If no category image exists, return a random image from assets
      final random = Random();
      final randomImageIndex = random.nextInt(3) +
          1; // Assuming you have three random images in assets

      return 'assets/images/profile.jpg';
    }
  }

  Future<void> _deleteCategory(
      BuildContext context, QueryDocumentSnapshot category) async {
    bool confirmDelete = await _showDeleteConfirmationDialog(context);
    if (confirmDelete) {
      try {
        // Delete associated images from Firebase Storage
        await _deleteProductImages(category['imageUrls'][0]);

        // Delete the category from Firestore
        await FirebaseFirestore.instance
            .collection(productsCollection)
            .doc(category.id)
            .delete();

        print('Product deleted successfully');
      } catch (e) {
        print('Error deleting product: $e');
      }
    }
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this product?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProductImages(dynamic imageUrlData) async {
    try {
      if (imageUrlData is List<String>) {
        for (String imageUrl in imageUrlData) {
          await _deleteImage(imageUrl);
        }
      } else if (imageUrlData is String) {
        await _deleteImage(imageUrlData);
      }
    } catch (e) {
      print('Error deleting product images: $e');
    }
  }

  Future<void> _deleteImage(String imageUrl) async {
    try {
      final firebase_storage.Reference storageReference =
          firebase_storage.FirebaseStorage.instance.refFromURL(imageUrl);
      await storageReference.delete();
      print('Image deleted successfully: $imageUrl');
    } catch (e) {
      print('Error deleting image: $e');
    }
  }
}
