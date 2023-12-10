import 'dart:io';

import 'package:babyshophub/views/admin/product/show-product.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  late List<File> _selectedImages = [];
  late List<String> _imageUrls = [];
  late double _price;
  late int _quantity;
  late String _selectedCategoryId = ""; // Add this for the selected category

  // Fetch categories and store them in a list
  List<Map<String, dynamic>> _categories = [
    {"id": "1", "name": "Category 1"},
    {"id": "2", "name": "Category 2"},
    // Add more categories as needed
  ];

  @override
  Widget build(BuildContext context) {
    return AdminCustomScaffold(
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
              DropdownButtonFormField(
                value: _selectedCategoryId,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category['id'],
                    child: Text(category['name']),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Select Category'),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value as String; // Add this type cast
                  });
                },
                validator: (value) {
                  if (value == null || (value as String).isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  _getImages();
                },
                child: Container(
                  color: Colors.blue,
                  padding: EdgeInsets.all(8),
                  child: Text('Select Images',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 16),
              getImagesWidget(),
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
    final imagePicker = ImagePicker();
    List<XFile>? pickedImages = await imagePicker.pickMultiImage();

    if (pickedImages != null) {
      if (pickedImages.length > 3) {
        // Limit the selection to a maximum of 3 images
        pickedImages = pickedImages.sublist(0, 3);
      }

      setState(() {
        _selectedImages = pickedImages!
            .where((image) =>
                image.path.toLowerCase().endsWith('.jpg') ||
                image.path.toLowerCase().endsWith('.jpeg') ||
                image.path.toLowerCase().endsWith('.png'))
            .map((image) => File(image.path))
            .toList();

        // Set _imageUrls to the paths
        _imageUrls = _selectedImages.map((image) => image.path).toList();

        if (kIsWeb) {
          // For web, use network paths directly
          _imageUrls = _selectedImages.map((image) => image.path).toList();
        }
      });
    }
  }

  Widget getImagesWidget() {
    if (_selectedImages.isNotEmpty) {
      return Column(
        children: _selectedImages.map((image) {
          if (kIsWeb) {
            // For web, use Image.network
            return Image.network(image.path, height: 100);
          } else {
            // For Android/iOS, check if the file exists before using Image.file
            if (image.existsSync()) {
              return Image.file(image, height: 100);
            } else {
              return Container();
            }
          }
        }).toList(),
      );
    } else {
      return Container();
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedImages.isNotEmpty) {
      _formKey.currentState!.save();

      // Now you can add the data to Firestore
      _addToFirestore();
    }
  }

  Future<void> _uploadImagesToStorage() async {
    try {
      for (int i = 0; i < _selectedImages.length; i++) {
        final storageReference = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('product_images')
            .child('${DateTime.now().millisecondsSinceEpoch}_$i');

        final uploadTask = storageReference.putFile(_selectedImages[i]);

        await uploadTask.whenComplete(() async {
          if (kIsWeb) {
            // For web, use _imageUrls directly
            _imageUrls[i] = await storageReference.getDownloadURL();
          } else {
            // For non-web, set _imageUrls from the local file paths
            _imageUrls[i] = _selectedImages[i].path;
          }
        });
      }
    } catch (e) {
      print('Error uploading images to storage: $e');
      // Handle the error as needed
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
      await _uploadImagesToStorage();
      // Add the data to Firestore
      FirebaseFirestore.instance.collection(productsCollection).add({
        'name': _productName,
        'description': _description,
        'price': _price,
        'quantity': _quantity,
        'category_id_fk': _selectedCategoryId,
        'imageUrls': _imageUrls,
        'status': 1,
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
