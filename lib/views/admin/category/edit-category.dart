import 'dart:io';

import 'package:babyshophub/consts/colors.dart';
import 'package:babyshophub/views/common/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditCategoryDialog extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String categoryDescription;
  final String categoryImageUrl;

  EditCategoryDialog({
    required this.categoryId,
    required this.categoryName,
    required this.categoryDescription,
    required this.categoryImageUrl,
  });

  @override
  _EditCategoryDialogState createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  bool temp = false;
  FilePickerResult? result;
  late File _selectedImage;
  Map<String, dynamic> updatedData = {};
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.categoryName);
    _descriptionController =
        TextEditingController(text: widget.categoryDescription);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return AlertDialog(
      title: Text("Edit Category"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              print("Container tapped!");
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    insetPadding: EdgeInsets.zero,
                    child: Container(
                      // width: context.screenWidth,
                      // height: context.screenHeight,
                      color: mainLightColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: textColor,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              print("Dialog closed");
                            },
                          ),
                          Expanded(
                              child: Container(
                            child: Image.network(widget.categoryImageUrl),
                          )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    await updateCategoryImage(
                                        newCategoryImageUrl: "",
                                        CatId: widget.categoryId);
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                    color: Colors.red,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(
                                        context); // Optionally close the pop-up
                                    showAddImageDialogBox();
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.lightBlue,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: CircleAvatar(
              radius: screenWidth * 0.1,
              backgroundImage: NetworkImage(widget.categoryImageUrl),
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: mainColor,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
          TextField(
            style: TextStyle(color: Colors.black),
            controller: _nameController,
            decoration: InputDecoration(labelText: "Name"),
          ),
          TextField(
            style: TextStyle(color: Colors.black),
            controller: _descriptionController,
            decoration: InputDecoration(labelText: "Description"),
          ),
          // Add other fields or widgets as needed...
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop({'name': _nameController.text, 'description': _descriptionController.text,'change':'0'}),
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            // Save the changes
            Navigator.of(context).pop({'name': _nameController.text, 'description': _descriptionController.text,'change':'1'});
            setState(() {});
          },
          child: Text("Save"),
        ),
      ],
    );
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

  void showAddImageDialogBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select New Profile'),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),

            // Add Button
            TextButton(
              onPressed: () async {
                // Upload the image to storage
                String? imageUrl = await _uploadImageToStorage();

                // Check if imageUrl is not null before further processing
                if (imageUrl != null) {
                  // Do something with the imageUrl, e.g., update UI or send to Firestore
                  print('New profile image URL: $imageUrl');
                  await updateCategoryImage(
                      newCategoryImageUrl: imageUrl, CatId: widget.categoryId);
                }

                // Close the dialog
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
          content: Column(
            children: [
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
              getImageWidget(),
            ],
          ), // Display the image widget or use other UI elements
        );
      },
    );
  }

  Future<void> updateCategoryImage(
      {required String newCategoryImageUrl, required String CatId}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userId = user.uid;

        // Update the CategoryImage field in the "users" collection
        await FirebaseFirestore.instance
            .collection('categories')
            .doc(userId)
            .update({
          'imageUrl': newCategoryImageUrl,
          'last_update_date': FieldValue.serverTimestamp(),
        });

        // Optionally, you can also update the user's profile in FirebaseAuth
        await user.updateProfile(photoURL: newCategoryImageUrl);

        print('CategoryImage updated successfully.');
// Optional: Display a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('CategoryImage updated successfully.'),
          ),
        );
        setState(() {});
      }
    } catch (e) {
      // Handle errors
      print('Error updating CategoryImage: $e');
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
            .child("category_images/${uniqueFileName}");

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
}
