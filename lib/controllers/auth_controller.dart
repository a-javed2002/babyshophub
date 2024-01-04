import 'dart:js_interop';

import 'package:babyshophub/views/common/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_twitter_login/flutter_twitter_login.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Future<UserCredential?> handleGoogleSignIn() async {
  //   try {
  //     final GoogleSignInAccount? googleSignInAccount =
  //         await googleSignIn.signIn();
  //     if (googleSignInAccount == null) {
  //       // User canceled the sign-in process
  //       return null;
  //     }

  //     final GoogleSignInAuthentication googleSignInAuthentication =
  //         await googleSignInAccount.authentication;

  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleSignInAuthentication.accessToken,
  //       idToken: googleSignInAuthentication.idToken,
  //     );

  //     final UserCredential userCredential =
  //         await _auth.signInWithCredential(credential);

  //     // Store user information in Firestore
  //     await _storeUserData(userCredential.user!);

  //     return userCredential;
  //   } catch (error) {
  //     print("Error signing in with Google: $error");
  //     return null;
  //   }
  // }

    Future<UserCredential?> handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        // User canceled the sign-in process
        return null;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Check if the user with the same email already exists in Firebase Authentication
      final existingUser = await _auth.fetchSignInMethodsForEmail(userCredential.user!.email!);

      if (existingUser.isEmpty) {
        // If the user doesn't exist, sign them up
        await _auth.createUserWithEmailAndPassword(
          email: userCredential.user!.email!,
          password: 'a_random_password', // You can generate a random password or use any desired method
        );
      }

      // Store user information in Firestore
      await _storeUserData(userCredential.user!);

      return userCredential;
    } catch (error) {
      print("Error signing in with Google: $error");
      return null;
    }
  }


  Future<void> _storeUserData(User user) async {
    // Store user information in Firestore
    await _firestore.collection('users').doc(user.uid).set({
      'image': user.photoURL,
      'username': user.displayName,
      'cnic': '',
      'email': user.email,
      'role': 'user',
      'imageUrl': user.photoURL.toString().isNotEmpty ? user.photoURL : '',
      'wishlist': [],
      'orders': [],
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

Future<User?> signInWithFacebook() async {
  try {
    // Perform Facebook Sign-In
    final LoginResult loginResult = await FacebookAuth.instance.login();

    if (loginResult.status != LoginStatus.success) {
      return null; // Facebook Sign-In failed
    }

    // Create a Facebook credential
    final AuthCredential credential = FacebookAuthProvider.credential(
      loginResult.accessToken!.token,
    );

    // Sign in with Facebook using Firebase Authentication
    UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = authResult.user;

    // Check if the user with the same email already exists in Firebase Authentication
    final existingUser = await FirebaseAuth.instance.fetchSignInMethodsForEmail(user!.email!);

    if (existingUser.isEmpty) {
      // If the user doesn't exist, store user information in Firestore
      await _storeUserData(user);
    }

    return user;
  } catch (e) {
    print("Facebook Sign In Error: $e");
    return null;
  }
}

  // Future<User?> signInWithTwitter() async {
  //   try {
  //     final TwitterLoginResult loginResult = await TwitterLogin(
  //       consumerKey: 'your_consumer_key',
  //       consumerSecret: 'your_consumer_secret',
  //     ).authorize();

  //     if (loginResult.status != TwitterLoginStatus.loggedIn) {
  //       return null; // Twitter Sign-In failed
  //     }

  //     final AuthCredential credential = TwitterAuthProvider.credential(
  //       accessToken: loginResult.session!.token,
  //       secret: loginResult.session!.secret,
  //     );

  //     UserCredential authResult = await _auth.signInWithCredential(credential);
  //     User? user = authResult.user;

  //     return user;
  //   } catch (e) {
  //     print("Twitter Sign In Error: $e");
  //     return null;
  //   }
  // }

  Future<void> logout(BuildContext context) async {
    try {
      // Clear user data from SharedPreferences
      await _clearUserDataFromSharedPreferences();

      // Sign out from Firebase Authentication
      await googleSignIn.signOut();
      await _auth.signOut();
      // await FacebookAuth.instance.logOut();
      // No specific sign-out method for Twitter
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
    prefs.remove('cart');
    prefs.remove('wishlist');
    // Add more fields to remove as needed
  }

  Future<UserCredential?> signInWithGithub() async {
  try {
    // Create a GithubAuthProvider
    GithubAuthProvider githubAuthProvider = GithubAuthProvider();

    // Sign in with Github using Firebase Authentication
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithProvider(githubAuthProvider);

    // Check if the user with the same email already exists in Firebase Authentication
    final existingUser = await FirebaseAuth.instance
        .fetchSignInMethodsForEmail(userCredential.user!.email!);

    if (existingUser.isEmpty) {
      // If the user doesn't exist, store user information in Firestore
      await _storeUserData(userCredential.user!);
    }

    return userCredential;
  } catch (error) {
    print("Error signing in with GitHub: $error");
    return null;
  }
}
}


