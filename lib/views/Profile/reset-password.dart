import 'package:babyshophub/views/home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _resetPassword();
              },
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resetPassword() async {
  try {
    String email = _emailController.text.trim();

    // Check if the email exists
    bool isEmailExists = await _isEmailExists(email);

    if (isEmailExists) {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Display success message or navigate to login screen
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Password Reset Email Sent'),
            content: Text('Check your email to reset your password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // You can navigate to the login screen or any other screen here
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Email Not Found'),
            content: Text('The provided email does not exist.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  } catch (e) {
    // Handle errors
    print('Error sending password reset email: $e');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to send password reset email.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

Future<bool> _isEmailExists(String email) async {
  try {
    // Query Firestore to check if the email exists in the "users" collection
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    // If any document is found, the email exists
    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    // Handle errors
    print('Error checking email existence: $e');
    return false;
  }
}
}
