import 'dart:io';

import 'package:babyshophub/views/common/admin-scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String _productName = '';
  String _selectedCategory = '';
  int _quantity = 0;
  double _price = 0.0;
  String _description = '';
  List<XFile> _selectedImages = [];

  late Stream<List<String>> _categoriesStream;

  @override
  void initState() {
    super.initState();
    _categoriesStream = _fetchCategories();
  }

  Stream<List<String>> _fetchCategories() {
    return FirebaseFirestore.instance.collection('categories').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc['name'].toString()).toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return AdminCustomScaffold(
      appBarTitle: "Add Product",
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Product Name'),
                onChanged: (value) {
                  setState(() {
                    _productName = value;
                  });
                },
              ),
              SizedBox(height: 16),
              StreamBuilder<List<String>>(
                stream: _categoriesStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  return DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    items: snapshot.data!.map((category) => DropdownMenuItem(
                          child: Text(category),
                          value: category,
                        )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Category'),
                  );
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _quantity = int.tryParse(value) ?? 0;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _price = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Implement image picker logic
                },
                child: Text('Select Images'),
              ),
              SizedBox(height: 16),
              // Display selected images
              _selectedImages.isNotEmpty
                  ? Column(
                      children: _selectedImages
                          .map(
                            (image) => Image.file(
                              File(image.path),
                              height: 100,
                            ),
                          )
                          .toList(),
                    )
                  : Container(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Implement form submission logic
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

  void _submitForm() {
    // Implement the logic to add product to database
    print('Product added to database');
  }
}
