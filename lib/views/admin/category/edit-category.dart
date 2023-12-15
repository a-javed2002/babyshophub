import 'dart:io';
import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/views/admin/category/show-category.dart';
import 'package:babyshophub/views/common/admin-scaffold.dart';
import 'package:babyshophub/views/common/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart' show kIsWeb;

class EditCategory extends StatefulWidget {
  final String categoryId;

  const EditCategory({Key? key, required this.categoryId}) : super(key: key);

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _categoryName;
  late String _description;
  late FilePickerResult? result;
  late File _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadCategoryDetails();
  }

  Future<void> _loadCategoryDetails() async {
    try {
      final DocumentSnapshot categoryDoc = await FirebaseFirestore.instance
          .collection(categoriesCollection)
          .doc(widget.categoryId)
          .get();

      setState(() {
        _categoryName = categoryDoc['name'];
        _description = categoryDoc['description'];
      });
    } catch (e) {
      print('Error loading category details: $e');
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
      appBarTitle: "Edit Category",
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _categoryName,
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _updateFirestore();
    }
  }

  Future<void> _updateFirestore() async {
    try {
      String? imageUrl;
      // Check if a new image is selected
      if (result != null && result!.files.isNotEmpty) {
        imageUrl = await _uploadImageToStorage();
        // Delete the previous image from storage
        await _deleteImageFromStorage();
      }

      // Update the category document in Firestore
      await FirebaseFirestore.instance
          .collection(categoriesCollection)
          .doc(widget.categoryId)
          .update({
        'name': _categoryName,
        'description': _description,
        'imageUrl': imageUrl,
        'last_update_date': FieldValue.serverTimestamp(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ShowCategory()),
      );

      Fluttertoast.showToast(
        msg: 'Category updated successfully',
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      print('Error updating category: $e');
      ToastWidget.show(
        message: 'Error updating category: $e',
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<String?> _uploadImageToStorage() async {
    try {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String uniqueFileName =
          '$timestamp${result!.files.single.name.replaceAll(" ", "_")}';

      await Firebase.initializeApp();
      firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child("category_images/${uniqueFileName}");

      await storageReference.putData(result!.files.single.bytes!);

      return await storageReference.getDownloadURL();
    } catch (e) {
      print('Error uploading image to storage: $e');
      ToastWidget.show(
        message: 'Error uploading image. Please try again.',
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return null;
    }
  }

  Future<void> _deleteImageFromStorage() async {
    try {
      final DocumentSnapshot categoryDoc = await FirebaseFirestore.instance
          .collection(categoriesCollection)
          .doc(widget.categoryId)
          .get();

      String? previousImageUrl = categoryDoc['imageUrl'];
      if (previousImageUrl != null) {
        firebase_storage.Reference storageReference =
            firebase_storage.FirebaseStorage.instance.refFromURL(
                previousImageUrl);

        await storageReference.delete();

        print('Previous image deleted successfully: $previousImageUrl');
      }
    } catch (e) {
      print('Error deleting previous image: $e');
    }
  }
}
