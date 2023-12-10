import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/views/common/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var isLoading = false;

  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;

    try {
      print(emailController.text);
      print(passwordController.text);
      userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      print("Error during sign in");
      print(e);
      String message = "An error occurred. Please try again later";
      if (e.code == 'user-not-found') {
        message = "No user found with that email. Please sign up first";
      } else if (e.code == 'wrong-password') {
        message = "Wrong password provided for that user";
      } else {
        message = e.message ?? message;
      }
      // VxToast.show(context, msg: message, showTime: 5000);
    }
    return userCredential;
  }

  Future<UserCredential?> signUpMethod({email, passowrd, context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print("error signup");
      // VxToast.show(context, msg: e.toString(), showTime: 5000);
    }
    return userCredential;
  }

  //storing data method
  storeUserData({name, password, email}) async {
    DocumentReference store =
        firestore.collection(userCollection).doc(currentUser!.uid);
    store.set({
      'name': name,
      'password': password,
      'email': email,
      'imageUrl': '',
      'id': currentUser!.uid,
      'cart_count': "00",
      'wishlist_count': "00",
      'order_count': "00"
    });
  }

  Future<void> logout(BuildContext context) async {
    try {
      // Clear user data from SharedPreferences
      await _clearUserDataFromSharedPreferences();

      // Sign out from Firebase Authentication
      await _auth.signOut();
    } catch (e) {
      print('Error during logout: $e');
      ToastWidget.show(
        message: 'Error during logout: $e',
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
    }
  }

  // Function to clear user data from SharedPreferences
  Future<void> _clearUserDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('username');
    prefs.remove('email');
    prefs.remove('role');
    // prefs.remove('cart');
    // prefs.remove('wishlist');
    // Add more fields to remove as needed
  }
}
