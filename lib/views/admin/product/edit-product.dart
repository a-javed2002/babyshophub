import 'dart:io';

import 'package:babyshophub/views/admin/product/show-product.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/views/common/admin-scaffold.dart';
import 'package:babyshophub/views/common/toast.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class EditProduct extends StatefulWidget {
  final String productId;

  const EditProduct({Key? key, required this.productId}) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _productName;
  late String _description;
  late double _price;
  late int _quantity;
  late String _selectedCategoryId = ""; // Add this for the selected category
  FilePickerResult? result;
  late File _selectedImage;

  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    // Fetch product details when the widget initializes
    _fetchProductDetails();
    // Fetch categories when the widget initializes
    _fetchCategories();
  }

  Future<void> _fetchProductDetails() async {
    try {
      final DocumentSnapshot productDoc = await FirebaseFirestore.instance
          .collection(productsCollection)
          .doc(widget.productId)
          .get();

      setState(() {
        _productName = productDoc['name'];
        _description = productDoc['description'];
        _price = productDoc['price'].toDouble();
        _quantity = productDoc['quantity'];
        _selectedCategoryId = productDoc['category_id_fk'];
      });
    } catch (e) {
      print('Error loading product details: $e');
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
      print("cat are");
      print(_categories);
    } catch (e) {
      print('Error fetching categories: $e');
      // Handle the error as needed
    }
  }

  Future<void> _getImage() async {
    try {
      result = await FilePicker.platform.pickFiles();
      if (result != null) {
        _selectedImage =
            File(result!.files.single.path!); // Store the selected image
      }
      print("File Selected!");
      setState(() {}); // Add setState to update the UI after selecting a file
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  Widget getImageWidget() {
    return result != null && result!.files.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(result!.files.single.name),
              SizedBox(height: 8),
              Image.file(_selectedImage,
                  height: 100, width: 100), // Show the selected image
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    result = null;
                    _selectedImage = File(''); // Clear the selected image
                  });
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.red), // Change button color to red
                child: Text(
                  'Remove',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return AdminCustomScaffold(
      context: context,
      appBarTitle: "Edit Product",
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _productName,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product name';
                  }
                  return null;
                },
                onSaved: (value) => _productName = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
                onSaved: (value) => _description = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _price.toString(),
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  return null;
                },
                onSaved: (value) => _price = double.parse(value!),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _quantity.toString(),
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the quantity';
                  }
                  return null;
                },
                onSaved: (value) => _quantity = int.parse(value!),
              ),
              SizedBox(height: 16),
              // DropdownButtonFormField<String>(
              //   value: _selectedCategoryId,
              //   items: _categories.map((category) {
              //     return DropdownMenuItem<String>(
              //       value: category['id'].toString(),
              //       child: Text(category['name']),
              //     );
              //   }).toList(),
              //   decoration: InputDecoration(labelText: 'Select Category'),
              //   onChanged: (value) {
              //     setState(() {
              //       _selectedCategoryId = value!;
              //     });
              //   },
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please select a category';
              //     }
              //     return null;
              //   },
              // ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _getImage();
                },
                style: ElevatedButton.styleFrom(
                  primary: result != null && result!.files.isNotEmpty
                      ? Colors.red
                      : Colors.blue,
                ),
                child: Text(
                  result != null && result!.files.isNotEmpty
                      ? 'Change Image'
                      : 'Select Image',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16),
              getImageWidget(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Check if the product name already exists
      bool isDuplicate = await _checkDuplicateProduct();

      if (isDuplicate) {
        // Handle duplicate product name
        print('Duplicate product name');
        ToastWidget.show(
          message: 'Duplicate product name. Please choose a different name.',
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
        );
      } else {
        // Upload the images to Firebase Storage
        String? imageUrl = await _uploadImageToStorage();

        try {
          // Update the data in Firestore
          await FirebaseFirestore.instance
              .collection(productsCollection)
              .doc(widget.productId)
              .update({
            'name': _productName,
            'description': _description,
            'price': _price,
            'quantity': _quantity,
            'category_id_fk': "IV9vIA3sIxrpiV5UB8zX",
            // 'category_id_fk': _selectedCategoryId,
            'imageUrls': imageUrl,
            'last_update_date': FieldValue.serverTimestamp(),
          });

          // Navigate back to the product list screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShowProduct()),
          );

          // Show a success message
          Fluttertoast.showToast(
            msg: 'Product updated successfully',
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        } catch (e) {
          print('Error updating product: $e');
          // Show an error message
          ToastWidget.show(
            message: 'Error updating product: $e',
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      }
    }
  }

  Future<String?> _uploadImageToStorage() async {
    try {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String uniqueFileName =
          '$timestamp${result!.files.single.name.replaceAll(" ", "_")}';

      if (result != null && result!.files.isNotEmpty) {
        await Firebase.initializeApp();
        firebase_storage.Reference storageReference = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child("product_images/${uniqueFileName}");

        await storageReference.putData(result!.files.single.bytes!);

        return await storageReference.getDownloadURL();
      }
    } catch (e) {
      print('Error uploading image to storage: $e');
      // Provide a user-friendly error message
      ToastWidget.show(
        message: 'Error uploading image. Please try again.',
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return null;
    }
  }

  Future<bool> _checkDuplicateProduct() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(productsCollection)
          .where('name', isEqualTo: _productName)
          .get();

      // Exclude the current product from the duplicate check
      if (querySnapshot.docs.isNotEmpty &&
          querySnapshot.docs.first.id != widget.productId) {
        return true;
      }

      return false;
    } catch (e) {
      print('Error checking duplicate product: $e');
      return false; // Assume no duplicate if there is an error
    }
  }
}
