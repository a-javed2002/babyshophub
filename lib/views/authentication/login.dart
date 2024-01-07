import 'package:animate_do/animate_do.dart';
import 'package:babyshophub/consts/colors.dart';
import 'package:babyshophub/controllers/auth_controller.dart';
import 'package:babyshophub/views/OnBoarding/onBoarding.dart';
import 'package:babyshophub/views/Profile/reset-password.dart';
import 'package:babyshophub/views/admin/dashboard.dart';
import 'package:babyshophub/views/common/loader.dart';
import 'package:babyshophub/views/common/pop-up.dart';
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
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  late AuthController _authController;

  void storeUserDataInSharedPreferences(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('username', userData['username']);
    prefs.setString('email', userData['email']);
    prefs.setString('role', userData['role'].toString().toLowerCase());
  }

  Future<bool> _checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool onboardingDone = prefs.getBool('onboardingDone') ?? false;

    return onboardingDone;
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
      storeUserDataInSharedPreferences(userData);

      try {
        bool onboardingDone = await _checkOnboardingStatus();

        if (onboardingDone) {
          var role = userData['role'].toString().toLowerCase();
          if (role == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyDashboard()),
            );
          } else if (role == 'user') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
          } else {
            print("error page navigator");
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OnBoardingScreen()),
          );
        }
      } catch (e) {
        print('Error during Navigation: $e');
      }
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
  void initState() {
    // TODO: implement initState
    super.initState();
    _authController = AuthController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeInUp(
                            duration: Duration(seconds: 1),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-1.png'))),
                            )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeInUp(
                            duration: Duration(milliseconds: 1200),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-2.png'))),
                            )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeInUp(
                            duration: Duration(milliseconds: 1300),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/clock.png'))),
                            )),
                      ),
                      Positioned(
                        child: FadeInUp(
                            duration: Duration(milliseconds: 1600),
                            child: Container(
                              margin: EdgeInsets.only(top: 50),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeInUp(
                          duration: Duration(milliseconds: 1800),
                          child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color:
                                          Color.fromARGB(255, 102, 131, 155)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: mainColor,
                                        blurRadius: 20.0,
                                        offset: Offset(0, 10))
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: _emailController
                                                  .text.isNotEmpty
                                              ? Colors
                                                  .green // Change color based on condition
                                              : Color.fromRGBO(
                                                  143, 148, 251, 1),
                                        ),
                                      ),
                                    ),
                                    child: TextField(
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                      style: TextStyle(color: Colors.black),
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Email",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[700]),
                                        prefixIcon: Icon(Icons
                                            .email), // Add icon to the left
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: _passwordController
                                                  .text.isNotEmpty
                                              ? Colors
                                                  .green // Change color based on condition
                                              : Color.fromRGBO(
                                                  143, 148, 251, 1),
                                        ),
                                      ),
                                    ),
                                    child: TextField(
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                      style: TextStyle(color: Colors.black),
                                      controller: _passwordController,
                                      obscureText: !_isPasswordVisible,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Password",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[700]),
                                        prefixIcon: Icon(
                                            Icons.lock), // Add icon to the left
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isPasswordVisible =
                                                  !_isPasswordVisible;
                                            });
                                          },
                                          child: Icon(
                                            _isPasswordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ))),
                      SizedBox(
                        height: 30,
                      ),
                      isLoading
                          ? CustomLoader()
                          : Column(
                              children: [
                                FadeInUp(
                                    duration: Duration(milliseconds: 1900),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (_emailController.text.isNotEmpty &&
                                            _passwordController
                                                .text.isNotEmpty) {
                                          login(_emailController.text,
                                              _passwordController.text);
                                        } else {
                                          CustomPopup(
                                            message: 'Fill All Fields',
                                            isSuccess: false,
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient: LinearGradient(
                                            colors: (_emailController
                                                        .text.isNotEmpty &&
                                                    _passwordController
                                                        .text.isNotEmpty)
                                                ? [
                                                    Color.fromRGBO(
                                                        34, 40, 138, 0.6),
                                                    Color.fromRGBO(
                                                        41, 51, 233, 0.6),
                                                  ]
                                                : [
                                                    Color.fromRGBO(
                                                        143, 148, 251, 1),
                                                    Color.fromRGBO(
                                                        143, 148, 251, .6),
                                                  ],
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Login",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                FadeInUp(
                                    duration: Duration(milliseconds: 1900),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SocialButton(
                                          image:
                                              'assets/icons/google_logo.png', // Replace with your Google logo image path
                                          onPressed: () async {
                                            UserCredential? userCredential =
                                                await _authController
                                                    .handleGoogleSignIn();
                                            if (userCredential != null) {
                                              print(
                                                  "Signed in: ${userCredential.user?.displayName}");
                                                  Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyHomePage()),
                                              );
                                              // Navigate to the next screen or perform other actions
                                            } else {
                                              print(
                                                  "Sign-in canceled or failed");
                                            }
                                          },
                                        ),
                                        SizedBox(width: 16),
                                        SocialButton(
                                          image:
                                              'assets/icons/facebook_logo.png', // Replace with your Facebook logo image path
                                          onPressed: () async {
                                            UserCredential? userCredential =
                                                await _authController
                                                    .signInWithFacebook();
                                            if (userCredential != null) {
                                              print(
                                                  "Signed in: ${userCredential}");
                                                  Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyHomePage()),
                                              );
                                              // Navigate to the next screen or perform other actions
                                            } else {
                                              print(
                                                  "Sign-in canceled or failed");
                                            }
                                          },
                                        ),
                                        SizedBox(width: 16),
                                        SocialButton(
                                          image:
                                              'assets/icons/github_logo.png', // Replace with your GitHub logo image path
                                          onPressed: () async {
                                            UserCredential? userCredential =
                                                await _authController
                                                    .signInWithGithub();
                                            if (userCredential != null) {
                                              print(
                                                  "Signed in: ${userCredential.user?.displayName}");
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyHomePage()),
                                              );
                                              // Navigate to the next screen or perform other actions
                                            } else {
                                              print(
                                                  "Sign-in canceled or failed");
                                            }
                                          },
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      FadeInUp(
                          duration: Duration(milliseconds: 2000),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ResetPasswordScreen()),
                              );
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  color: Color.fromRGBO(143, 148, 251, 1)),
                            ),
                          )),
                      FadeInUp(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?",
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.6))),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpPage()),
                                );
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Color.fromRGBO(34, 40, 138, 0.6)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class SocialButton extends StatelessWidget {
  final String image;
  final VoidCallback onPressed;

  SocialButton({required this.image, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200], // You can set your desired background color
        ),
        child: Center(
          child: Image.asset(
            image,
            width: 30,
            height: 30,
          ),
        ),
      ),
    );
  }
}
