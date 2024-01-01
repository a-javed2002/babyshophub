import 'dart:io';

import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/controllers/cart_controller.dart';
import 'package:babyshophub/views/Orders/orders.dart';
import 'package:babyshophub/views/Product/cart.dart';
import 'package:babyshophub/views/Product/wishlist.dart';
import 'package:babyshophub/views/Profile/settings.dart';
import 'package:babyshophub/views/admin/order/orders.dart';
import 'package:babyshophub/views/common/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CartController _cartController = CartController();
  late String userId;
  String username = '';
  String email = '';
  String role = '';
  String cnic = '';
  String imageUrl = '';
  bool temp = false;
  String timestamp = '';
  List orders = [];
  List wishlist = [];
  List address = [];
  List contact = [];
  List cart = [];
  FilePickerResult? result;
  late File _selectedImage;

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
            .child("profile_images/${uniqueFileName}");

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

  Future<void> updateProfileImage({required String newProfileImageUrl}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userId = user.uid;

        // Update the profileImage field in the "users" collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'imageUrl': newProfileImageUrl,
        });

        // Optionally, you can also update the user's profile in FirebaseAuth
        await user.updateProfile(photoURL: newProfileImageUrl);

        print('ProfileImage updated successfully.');
// Optional: Display a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ProfileImage updated successfully.'),
          ),
        );
        setState(() {});
      }
    } catch (e) {
      // Handle errors
      print('Error updating profileImage: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserId().then((uid) {
      if (uid != null) {
        setState(() {
          userId = uid;
        });
        _fetchUserData();
      }
    });
  }

  Future<String?> _getUserId() async {
    final User? user = _auth.currentUser;
    return user?.uid;
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        cart = await _cartController.getCartData();
        setState(() {
          username = userSnapshot['username'];
          email = userSnapshot['email'];
          role = userSnapshot['role'];
          cnic = userSnapshot['cnic'];
          temp = userSnapshot['imageUrl'] == "";
          imageUrl = userSnapshot['imageUrl'] == ""
              ? "assets/images/profile.jpg"
              : userSnapshot['imageUrl'];
          orders = userSnapshot['orders'];
          wishlist = userSnapshot['wishlist'];
          timestamp = userSnapshot['timestamp'].toString();
          address = userSnapshot['address'];
          contact = userSnapshot['contact'];
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: screenWidth * 0.06,
                      ),
                      child: Text(
                        "$username",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.05,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: screenWidth * 0.02,
                      ),
                      child: Text(
                        "$email",
                        style: TextStyle(
                            color: Colors.grey, fontSize: screenWidth * 0.03),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyOrdersScreen(),
                        ),
                      );
                    },
                    child: Icon(Icons.message,
                        color: textColor, size: screenWidth * 0.06),
                  ),
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
                                    child: temp
                                        ? Image.asset(imageUrl)
                                        : Image.network(imageUrl),
                                  )),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            await updateProfileImage(
                                                newProfileImageUrl: "");
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
                      backgroundImage: temp
                          ? AssetImage("$imageUrl")
                          : NetworkImage("$imageUrl") as ImageProvider<Object>?,
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
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(),
                          ),
                        );
                      },
                      child: Icon(Icons.settings,
                          color: textColor, size: screenWidth * 0.06)),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyOrdersScreen(),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${orders.length}",
                          style: TextStyle(
                              color: Colors.purple,
                              fontSize: screenWidth * 0.04),
                        ),
                        Text(
                          "Orders",
                          style: TextStyle(
                              color: Colors.grey, fontSize: screenWidth * 0.03),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WishlistScreen(),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${wishlist.length}",
                          style: TextStyle(
                              color: Colors.purple,
                              fontSize: screenWidth * 0.04),
                        ),
                        Text(
                          "Wishlist",
                          style: TextStyle(
                              color: Colors.grey, fontSize: screenWidth * 0.03),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartScreen(),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${cart.length}",
                          style: TextStyle(
                              color: Colors.purple,
                              fontSize: screenWidth * 0.04),
                        ),
                        Text(
                          "Cart",
                          style: TextStyle(
                              color: Colors.grey, fontSize: screenWidth * 0.03),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            // Expanded(
            //   flex: 1,
            //   child: Center(
            //     child: Text(
            //       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua",
            //       textAlign: TextAlign.center,
            //       style: TextStyle(fontSize: screenWidth * 0.04),
            //     ),
            //   ),
            // ),
            // const Divider(),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  address.length > 0
                      ? Row(
                          children: [
                            Text("Addresses Are:"),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Container(
                                height: 50,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: address.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        address[index],
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Text("No Address"),
                        ),
                  contact.length > 0
                      ? Row(
                          children: [
                            Text("Contact Are:"),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Container(
                                height: 50,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: contact.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        contact[index],
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Text("No Contact"),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
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
                  await updateProfileImage(newProfileImageUrl: imageUrl);
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
}
