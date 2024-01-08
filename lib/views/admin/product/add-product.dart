import 'dart:io';

import 'package:babyshophub/views/admin/product/show-product.dart';
import 'package:babyshophub/views/common/loader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/views/common/admin-scaffold.dart';
import 'package:babyshophub/views/common/toast.dart';

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
  late String _selectedCategoryId = "";
  List<PlatformFile> selectedFiles = [];
  bool isLoading = false;

  List<Map<String, dynamic>> _categories = [];
  Map<String, dynamic>? _selectedCategory;

  @override
  void initState() {
    super.initState();
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
        _selectedCategoryId = _categories[0]['id'];
        _selectedCategory = _categories[0];
      }
      print("Categories are:");
      print(_categories);
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> _getImages() async {
    try {
      FilePickerResult? pickedFiles = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (pickedFiles != null && pickedFiles.files.isNotEmpty) {
        print("Files Selected: ${pickedFiles.files.length}");

        setState(() {
          selectedFiles = pickedFiles.files;
        });
      } else {
        print("No files selected.");
      }
    } catch (e) {
      print("Error picking files: $e");
    }
  }

  Widget getImageWidget() {
    return selectedFiles.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Selected Images:'),
              SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: selectedFiles.length,
                itemBuilder: (context, index) {
                  final file = selectedFiles[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(file.name),
                      SizedBox(height: 8),
                      Image.file(File(file.path!),
                          height: 100, width: 100),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedFiles.removeAt(index);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          )
        : Container();
  }

  Future<List<String?>> _uploadImagesToStorage() async {
    List<String?> imageUrls = [];
    try {
      for (var file in selectedFiles) {
        String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        String uniqueFileName = '$timestamp${file.name.replaceAll(" ", "_")}';

        firebase_storage.Reference storageReference =
            firebase_storage.FirebaseStorage.instance
                .ref()
                .child("product_images/$uniqueFileName");

        await storageReference.putData(file.bytes!);

        imageUrls.add(await storageReference.getDownloadURL());
      }
      return imageUrls;
    } catch (e) {
      print('Error uploading images to storage: $e');
      ToastWidget.show(
        message: 'Error uploading images. Please try again.',
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return [];
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && selectedFiles.isNotEmpty) {
      _formKey.currentState!.save();
      _addToFirestore();
    }
  }

  void _addToFirestore() async {
    bool isDuplicate = await _checkDuplicateProduct();
setState(() {
        isLoading = true; // Set isLoading to true before signup
      });
    if (isDuplicate) {
      print('Duplicate product name');
      ToastWidget.show(
        message: 'Duplicate product name. Please choose a different name.',
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
    } else {
      List<String?> imageUrls = await _uploadImagesToStorage();
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final User? user = _auth.currentUser;
      String currentUserUid = user!.uid;

      FirebaseFirestore.instance.collection(productsCollection).add({
        'name': _productName,
        'description': _description,
        'price': _price,
        'quantity': _quantity,
        'category_id_fk': _selectedCategoryId,
        'imageUrls': imageUrls,
        'status': 1,
        'feedback': [],
        'addedBy': currentUserUid,
        'timestamp': FieldValue.serverTimestamp(),
        'last_update_date': FieldValue.serverTimestamp(),
      }).then((value) {
        print('Product added to Firestore');
        _formKey.currentState!.reset();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShowProduct()),
        );
      }).catchError((error) {
        print('Error adding product to Firestore: $error');
        ToastWidget.show(
          message: 'Error adding product to Firestore: $error',
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
        );
      });
    }

    setState(() {
        isLoading = false; // Set isLoading to true before signup
      });
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
      return false;
    }
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
                  _getImages();
                },
                style: ElevatedButton.styleFrom(
                  primary: selectedFiles.isNotEmpty ? Colors.red : Colors.blue,
                ),
                child: Text(
                  selectedFiles.isNotEmpty ? 'Change Images' : 'Select Images',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16),
              // getImageWidget(),
              SizedBox(height: 16),
              isLoading
                          ? CustomLoader()
                          :ElevatedButton(
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
}
