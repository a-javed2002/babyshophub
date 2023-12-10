import 'dart:io';

import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/views/common/admin-scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _categoryName;
  late String _description;
  late String
      _imageUrl; // You can use this to store the URL of the selected image
  late File _selectedImage = File('');

Future<void> _getImage() async {
  final imagePicker = ImagePicker();
  final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

  if (pickedImage != null) {
    setState(() {
      _selectedImage = File(pickedImage.path);
      _imageUrl = pickedImage.path; // Set _imageUrl to the path
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return AdminCustomScaffold(
      appBarTitle: "Add Category",
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Category Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the category name';
                  }
                  return null;
                },
                onSaved: (value) => _categoryName = value!,
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
              GestureDetector(
                onTap: () {
                  _getImage();
                },
                child: Container(
                  color: Colors.blue,
                  padding: EdgeInsets.all(8),
                  child: Text('Select Image',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 16),
              _selectedImage != null
                  ? Image.file(_selectedImage, height: 100)
                  : Container(),
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

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      _formKey.currentState!.save();

      // Now you can add the data to Firestore
      _addToFirestore();
    }
  }

  Future<void> _uploadImageToStorage() async {
    try {
      final storageReference = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('category_images')
          .child(DateTime.now().millisecondsSinceEpoch.toString());

      final uploadTask = storageReference.putFile(_selectedImage);

      await uploadTask.whenComplete(() async {
        _imageUrl = await storageReference.getDownloadURL();
      });
    } catch (e) {
      print('Error uploading image to storage: $e');
    }
  }

  void _addToFirestore() async {
    // Upload the image to Firebase Storage
    await _uploadImageToStorage();

    // Now, add the data to Firestore
    FirebaseFirestore.instance.collection(categoriesCollection).add({
      'name': _categoryName,
      'description': _description,
      'imageUrl': _imageUrl,
    }).then((value) {
      // Handle success
      print('Category added to Firestore');
    }).catchError((error) {
      // Handle error
      print('Error adding category to Firestore: $error');
    });
  }
}
