import 'package:babyshophub/views/OnBoarding/onBoarding.dart';
import 'package:babyshophub/views/common/loader.dart';
import 'package:babyshophub/views/common/pop-up.dart';
import 'package:babyshophub/main.dart';
import 'package:babyshophub/views/authentication/signup.dart';
import 'package:babyshophub/views/home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  TextEditingController _emailController = TextEditingController(text: "a@a.com");
  TextEditingController _passwordController = TextEditingController(text: "123456");

  _checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool onboardingDone = prefs.getBool('onboardingDone') ?? false;

    if (onboardingDone) {
      // Onboarding is done, navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
    else{
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnBoardingScreen()),
      );
    }
  }

  String _validateFields() {
    String msg = '';

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      msg += 'All fields are required.\n';
    }

    if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
        .hasMatch(_emailController.text)) {
      msg += 'Enter a valid email address.\n';
    }

    return msg;
  }

  Future<void> login(String email, String password) async {
    try {
      setState(() {
        isLoading = true; // Set isLoading to true before signup
      });
      // Sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Retrieve user data from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      setState(() {
        isLoading = false; // Set isLoading to true before signup
      });
      CustomPopup(
        message: 'User signed In successfully!',
        isSuccess: true,
      );
      // Navigate to home page or perform other actions after successful login
      print('User logged in successfully!');
      print('Username: ${userData['username']}');
      print('Email: ${userData['email']}');
      print('Role: ${userData['role']}');

      _checkOnboardingStatus();

      
    } catch (e) {
      print('Error during login: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomPopup(
            message: 'Error during login: $e',
            isSuccess: false,
          );
        },
      );
      setState(() {
        isLoading = false; // Set isLoading to true before signup
      });
      // Handle login errors here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
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
              onPressed: () {
                // Implement login functionality here
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
                  login(_emailController.text, _passwordController.text);
                }
              },
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
