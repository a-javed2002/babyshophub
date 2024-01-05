import 'dart:io';

import 'package:babyshophub/consts/colors.dart';
import 'package:babyshophub/views/common/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditProductDialog extends StatefulWidget {
  final String productId;
  final String productName;
  final String productDescription;
  final String productStatus;
  final String productPrice;
  final String productQuantity;
  final List<String> productImageUrl;

  EditProductDialog({
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.productImageUrl,
    required this.productPrice,
    required this.productStatus,
    required this.productQuantity,
  });

  @override
  _EditProductDialogState createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  bool temp = false;
  FilePickerResult? result;
  late File _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.productName);
    _descriptionController =
        TextEditingController(text: widget.productDescription);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return AlertDialog(
      title: Text("Edit Product"),
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
                            child: Image.network(widget.productImageUrl[0]),
                          )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    await removeProductImageUrl(
                                        imageUrlToRemove: widget.productImageUrl[0],
                                        productId: widget.productId);
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
              backgroundImage: NetworkImage(widget.productImageUrl[0]),
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
            controller: _nameController,
            decoration: InputDecoration(labelText: "Name"),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: "Description"),
          ),
          // Add other fields or widgets as needed...
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            // Save the changes
            Navigator.of(context).pop(true);
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
                  await updateProductImage(
                      newProductImageUrl: imageUrl, productId: widget.productId);
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

  Future<void> updateProductImage({
  required String newProductImageUrl,
  required String productId,
}) async {
  try {
    // Update the imageUrls field in the "products" collection
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update({
      'imageUrls': FieldValue.arrayUnion([newProductImageUrl]),
    });

    print('ProductImage updated successfully.');
    // Optional: Display a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ProductImage updated successfully.'),
      ),
    );
    setState(() {});
  } catch (e) {
    // Handle errors
    print('Error updating ProductImage: $e');
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

  Future<void> removeProductImageUrl({
  required String imageUrlToRemove,
  required String productId,
}) async {
  try {
    // Remove the imageUrlToRemove from the imageUrls field in the "products" collection
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update({
      'imageUrls': FieldValue.arrayRemove([imageUrlToRemove],
      ),
    });

    // Remove the image from Firestore Storage
    final storageReference =
        FirebaseStorage.instance.ref().child('product_images/$productId');

    await storageReference.child(imageUrlToRemove).delete();

    print('ProductImage removed successfully.');
    // Optional: Display a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ProductImage removed successfully.'),
      ),
    );
    setState(() {});
  } catch (e) {
    // Handle errors
    print('Error removing ProductImage: $e');
  }
}

}
