import 'package:animate_do/animate_do.dart';
import 'package:babyshophub/consts/colors.dart';
import 'package:babyshophub/views/OnBoarding/onBoarding.dart';
import 'package:babyshophub/views/admin/dashboard.dart';
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
  TextEditingController _emailController =
      TextEditingController(text: "y@y.com");
  TextEditingController _passwordController =
      TextEditingController(text: "123456");

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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login Page'),
        ),
        // body: Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       TextField(
        //         controller: _emailController,
        //         decoration: InputDecoration(
        //           labelText: 'Email',
        //         ),
        //       ),
        //       SizedBox(height: 20),
        //       TextField(
        //         controller: _passwordController,
        //         obscureText: true,
        //         decoration: InputDecoration(
        //           labelText: 'Password',
        //         ),
        //       ),
        //       SizedBox(height: 20),
        //       isLoading?CustomLoader():
        //       ElevatedButton(
        //         onPressed: () {
        //           // Implement login functionality here
        //           String msg = _validateFields();
        //           if (msg != '') {
        //             showDialog(
        //               context: context,
        //               builder: (BuildContext context) {
        //                 return CustomPopup(
        //                   message: msg,
        //                   isSuccess: false,
        //                 );
        //               },
        //             );
        //           } else {
        //             login(_emailController.text, _passwordController.text);
        //           }
        //         },
        //         child: Text('Login'),
        //       ),
        //       SizedBox(height: 10),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text("Don't have an account?"),
        //     TextButton(
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(builder: (context) => SignUpPage()),
        //         );
        //       },
        //       child: Text('Sign Up'),
        //     ),
        //   ],
        // ),
        //     ],
        //   ),
        // ),
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
                                    color: Color.fromARGB(255, 102, 131, 155)),
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
                                              color: Color.fromRGBO(
                                                  143, 148, 251, 1)))),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Email",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[700])),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Password",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[700])),
                                  ),
                                )
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      FadeInUp(
                          duration: Duration(milliseconds: 1900),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(colors: [
                                  Color.fromRGBO(143, 148, 251, 1),
                                  Color.fromRGBO(143, 148, 251, .6),
                                ])),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 70,
                      ),
                      FadeInUp(
                          duration: Duration(milliseconds: 2000),
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                color: Color.fromRGBO(143, 148, 251, 1)),
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()),
                              );
                            },
                            child: Text('Sign Up'),
                          ),
                        ],
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
