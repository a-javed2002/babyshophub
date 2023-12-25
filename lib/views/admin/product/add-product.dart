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

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _productName;
  late String _description;
  late double _price;
  late int _quantity;
  late String _selectedCategoryId = ""; // Add this for the selected category
  FilePickerResult? result;
  late File _selectedImage;

  List<Map<String, dynamic>> _categories = [];
  Map<String, dynamic>? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Fetch categories when the widget initializes
    _fetchCategories();
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
      if (_categories.isNotEmpty) {
        // Set the ID of the default selected category
        _selectedCategoryId = _categories[0]['id'];
        _selectedCategory = _categories[0]['name'];
      }
      print("Categories are:");
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
      appBarTitle: "Add Product",
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _categories.isEmpty
                      ? Text(
                          'No categories found',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        )
                      : DropdownButton<Map<String, dynamic>>(
                          value: _selectedCategory ??
                              (_categories.isNotEmpty ? _categories[0] : null),
                          onChanged: (Map<String, dynamic>? newValue) {
                            // Handle the selected category
                            setState(() {
                              _selectedCategory = newValue;
                              _selectedCategoryId = newValue?['id'] ?? '';
                            });
                            print("Selected category: ${newValue?['name']}");
                            print("Selected category ID: ${newValue?['id']}");
                          },
                          items: _categories
                              .map<DropdownMenuItem<Map<String, dynamic>>>(
                                  (category) {
                            return DropdownMenuItem<Map<String, dynamic>>(
                              value: category,
                              child: Text(category['name']),
                            );
                          }).toList(),
                        ),
                ],
              ),
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

  Future<void> _getImages() async {
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

  void _submitForm() {
    if (_formKey.currentState!.validate() && result != null) {
      _formKey.currentState!.save();

      // Now you can add the data to Firestore
      _addToFirestore();
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

  void _addToFirestore() async {
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
      // Add the data to Firestore
      FirebaseFirestore.instance.collection(productsCollection).add({
        'name': _productName,
        'description': _description,
        'price': _price,
        'quantity': _quantity,
        // 'category_id_fk': "IV9vIA3sIxrpiV5UB8zX",
        'category_id_fk': _selectedCategoryId,
        'imageUrls': imageUrl,
        'status': 1,
        'feedback': [],
        'timestamp': FieldValue.serverTimestamp(),
        'last_update_date': FieldValue.serverTimestamp(),
      }).then((value) {
        // Handle success
        print('Product added to Firestore');
        _formKey.currentState!.reset();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShowProduct()),
        );
      }).catchError((error) {
        // Handle error
        print('Error adding product to Firestore: $error');
        ToastWidget.show(
          message: 'Error adding product to Firestore: $error',
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
        );
      });
    }
  }

  Future<bool> _checkDuplicateProduct() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(productsCollection)
          .where('name', isEqualTo: _productName)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking duplicate product: $e');
      return false; // Assume no duplicate if there is an error
    }
  }
}
