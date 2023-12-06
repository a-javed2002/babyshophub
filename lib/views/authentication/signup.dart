import 'package:babyshophub/views/common/loader.dart';
import 'package:babyshophub/views/common/pop-up.dart';
import 'package:babyshophub/views/authentication/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  String _username = '';
  String _cnic = '';
  String _email = '';
  String _password = '';
  String _selectedRole = 'user';

  String _validateFields() {
    String msg = '';

    if (_username.isEmpty || _email.isEmpty || _password.isEmpty || _cnic.isEmpty) {
      msg += 'All fields are required.\n';
    }

    if (_username.length < 3) {
      msg += 'Username must be at least 3 characters.\n';
    }

    if (_cnic.length < 10) {
      msg += 'CNIC must be at least 10 characters.\n';
    }

    if (_password.length < 6) {
      msg += 'Password must be at least 6 characters.\n';
    }

    if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(_email)) {
      msg += 'Enter a valid email address.\n';
    }

    return msg;
  }

  Future<void> signUp() async {
    try {
      setState(() {
        isLoading = true; // Set isLoading to true before signup
      });
      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      // Store additional user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': _username,
        'cnic': _cnic,
        'email': _email,
        'role': _selectedRole,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Navigate to home page or perform other actions after successful signup
      print('User signed up successfully!');
      setState(() {
        isLoading = false; // Set isLoading back to false after successful signup
      });
      CustomPopup(
        message: 'User signed up successfully!',
        isSuccess: true,
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      setState(() {
        isLoading = false; // Set isLoading back to false after successful signup
      });
      print('Error during signup: $e');
      CustomPopup(
        message: 'Error during signup: $e',
        isSuccess: false,
      );
      // Handle signup errors here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _username = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  _cnic = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'CNIC',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20),
            Visibility(
              visible: isLoading,
              child: CustomLoader(), // Add your loader widget here
            ),
            ElevatedButton(
              onPressed: () async {
                // Implement sign-up functionality here
                print('Username: $_username');
                print('Email: $_email');
                print('Password: $_password');
                print('Role: $_selectedRole');
                String msg = _validateFields();
                if (msg != '') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomPopup(
                        message: msg,
                        isSuccess: false,
                      );
                    },
                  );
                } else {
                  signUp();
                }
              },
              child: Text('Sign Up'),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    // Navigate to the login page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
