import 'package:animate_do/animate_do.dart';
import 'package:babyshophub/consts/consts.dart';
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
  bool _isPasswordVisible = false;

  String _validateFields() {
    String msg = '';

    if (_username.isEmpty ||
        _email.isEmpty ||
        _password.isEmpty ||
        _cnic.isEmpty) {
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
        'wishlist': [],
        'orders': [],
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Navigate to home page or perform other actions after successful signup
      print('User signed up successfully!');
      setState(() {
        isLoading =
            false; // Set isLoading back to false after successful signup
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
        isLoading =
            false; // Set isLoading back to false after successful signup
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
        // appBar: AppBar(
        //   title: Text('Sign Up Page'),
        // ),
        // body: Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       TextField(
        //         onChanged: (value) {
        //           setState(() {
        //             _username = value;
        //           });
        //         },
        //         decoration: InputDecoration(
        //           labelText: 'Username',
        //         ),
        //       ),
        //       SizedBox(height: 20),
        //       TextField(
        //         onChanged: (value) {
        //           setState(() {
        //             _cnic = value;
        //           });
        //         },
        //         decoration: InputDecoration(
        //           labelText: 'CNIC',
        //         ),
        //       ),
        //       SizedBox(height: 20),
        //       TextField(
        //         onChanged: (value) {
        //           setState(() {
        //             _email = value;
        //           });
        //         },
        //         decoration: InputDecoration(
        //           labelText: 'Email',
        //         ),
        //       ),
        //       SizedBox(height: 20),
        //       TextField(
        //         onChanged: (value) {
        //           setState(() {
        //             _password = value;
        //           });
        //         },
        //         obscureText: true,
        //         decoration: InputDecoration(
        //           labelText: 'Password',
        //         ),
        //       ),
        //       SizedBox(height: 20),
        //       Visibility(
        //         visible: isLoading,
        //         child: CustomLoader(), // Add your loader widget here
        //       ),
        //       ElevatedButton(
        //         onPressed: () async {
        //           // Implement sign-up functionality here
        //           print('Username: $_username');
        //           print('Email: $_email');
        //           print('Password: $_password');
        //           print('Role: $_selectedRole');
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
        //             signUp();
        //           }
        //         },
        //         child: Text('Sign Up'),
        //       ),
        //       SizedBox(height: 10),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Text("Already have an account?"),
        //           TextButton(
        //             onPressed: () {
        //               // Navigate to the login page
        //               Navigator.push(
        //                 context,
        //                 MaterialPageRoute(builder: (context) => LoginPage()),
        //               );
        //             },
        //             child: Text('Login'),
        //           ),
        //         ],
        //       ),
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
                                  "Sign Up",
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
                                          color:
                                              Color.fromRGBO(143, 148, 251, 1),
                                        ),
                                      ),
                                    ),
                                    child: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          _username = value;
                                        });
                                      },
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Email",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[700]),
                                        prefixIcon: Icon(Icons
                                            .person), // Add icon to the left
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color:
                                              Color.fromRGBO(143, 148, 251, 1),
                                        ),
                                      ),
                                    ),
                                    child: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          _cnic = value;
                                        });
                                      },
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "CNIC",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[700]),
                                        prefixIcon: Icon(Icons
                                            .document_scanner), // Add icon to the left
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color:
                                              Color.fromRGBO(143, 148, 251, 1),
                                        ),
                                      ),
                                    ),
                                    child: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          _email = value;
                                        });
                                      },
                                      style: TextStyle(color: Colors.black),
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
                                          color:
                                              Color.fromRGBO(143, 148, 251, 1),
                                        ),
                                      ),
                                    ),
                                    child: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          _password = value;
                                        });
                                      },
                                      style: TextStyle(color: Colors.black),
                                      // controller: _passwordController,
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
                      FadeInUp(
                          duration: Duration(milliseconds: 1900),
                          child: isLoading
                                  ? CustomLoader()
                                  :GestureDetector(
                                    onTap: () {
                                if (_validateFields() == '') {
                                  signUp();
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
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  gradient: LinearGradient(
                                                                    colors: (_validateFields() == '')
                                      ? [
                                          Color.fromRGBO(34, 40, 138, 0.6),
                                          Color.fromRGBO(41, 51, 233, 0.6),
                                        ]
                                      : [
                                          Color.fromRGBO(143, 148, 251, 1),
                                          Color.fromRGBO(143, 148, 251, .6),
                                        ],
                                                                  ),
                                                                ),
                                                                child: Center(
                                      child: Text(
                                        "Sign Up",
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account?",
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.6))),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              },
                              child: Text(
                                'Login',
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
}
