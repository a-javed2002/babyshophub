import 'dart:async';

import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/views/OnBoarding/onBoarding.dart';
import 'package:babyshophub/views/admin/dashboard.dart';
import 'package:babyshophub/views/authentication/login.dart';
import 'package:babyshophub/views/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Function to retrieve user data from SharedPreferences
  Future<Map<String, dynamic>> getUserDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String username = prefs.getString('username') ?? '';
    String email = prefs.getString('email') ?? '';
    String role = prefs.getString('role') ?? '';

    return {
      'username': username,
      'email': email,
      'role': role,
    };
  }

  Future<bool> isUserLoggedIn() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  _checkOnboardingStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool onboardingDone = prefs.getBool('onboardingDone') ?? false;
      print("checking....");
      if (onboardingDone) {
        bool loggedIn = await isUserLoggedIn();
        if (loggedIn) {
          // To retrieve the stored data
          Map<String, dynamic> storedUserData =
              await getUserDataFromSharedPreferences();
          var role = storedUserData['role'].toString().toLowerCase();

          // Onboarding is done, check if the user is logged in
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
          }
        } else {
          print(
              'User is not logged in but onboarding is done before. Perform login.');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      } else {
        // Onboarding is not done, navigate to the onboarding screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnBoardingScreen()),
        );
      }
    } on Exception catch (e) {
      print('Error during onboarding status check: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      print("checking onBoarding Status");
      _checkOnboardingStatus();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: mainColor, body: content(context));
  }

  Widget content(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Use Expanded to make the animation take available vertical space
        Expanded(
          child: Lottie.asset("assets/animations/main.json"),
        ),
        SizedBox(height: 16), // Add some spacing between animation and text
        Text(
          "BABY SHOP HUB",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        SizedBox(height: 16), // Add some spacing between text and bottom credits
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Credits: @AbdJav",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
