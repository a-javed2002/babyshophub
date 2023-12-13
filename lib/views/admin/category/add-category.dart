import 'dart:io';
import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/views/admin/category/show-category.dart';
import 'package:babyshophub/views/common/admin-scaffold.dart';
import 'package:babyshophub/views/common/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart' show kIsWeb;

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _categoryName;
  late String _description;
  late String _imageUrl = "";
  late File _selectedImage = File('');

  Future<void> _getImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _imageUrl = pickedImage.path;

        if (kIsWeb) {
          _imageUrl = pickedImage.path;
        }
      });
    }
  }

  Widget getImageWidget() {
    if (_imageUrl != null && _imageUrl.isNotEmpty) {
      return Image.network(_imageUrl, height: 100);
    } else {
      return Container();
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

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      _formKey.currentState!.save();
      _addToFirestore();
    }
  }

  Future<void> _uploadImageToStorage() async {
  try {
    if (kIsWeb) {
      // For web, use _imageUrl directly
      _imageUrl = _selectedImage.path;
    } else {
      final storageReference = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('category_images')
          .child(DateTime.now().millisecondsSinceEpoch.toString());

      final uploadTask = storageReference.putFile(_selectedImage);

      await uploadTask.whenComplete(() async {
        _imageUrl = await storageReference.getDownloadURL();
        print('Image uploaded successfully!');
      });
    }
  } catch (e) {
    print('Error uploading image to storage: $e');
  }
}

  void _addToFirestore() async {
    bool isDuplicate = await _checkDuplicateCategory();

    if (isDuplicate) {
      print('Duplicate category name');
      ToastWidget.show(
        message: 'Duplicate category name. Please choose a different name.',
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
    } else {
      await _uploadImageToStorage();
      FirebaseFirestore.instance.collection(categoriesCollection).add({
        'name': _categoryName,
        'description': _description,
        'imageUrl': _imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'last_update_date': FieldValue.serverTimestamp(),
      }).then((value) {
        print('Category added to Firestore');
        _formKey.currentState!.reset();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShowCategory()),
        );
      }).catchError((error) {
        print('Error adding category to Firestore: $error');
        ToastWidget.show(
          message: 'Error adding category to Firestore: $error',
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
        );
      });
    }
  }

  Future<bool> _checkDuplicateCategory() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(categoriesCollection)
          .where('name', isEqualTo: _categoryName)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking duplicate category: $e');
      return false;
    }
  }
}
