import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/views/OnBoarding/onBoarding.dart';
import 'package:babyshophub/views/authentication/login.dart';
import 'package:babyshophub/views/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _checkOnboardingStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool onboardingDone = prefs.getBool('onboardingDone') ?? false;
      print("checking....");
      if (onboardingDone) {
        // Onboarding is done, check if the user is logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
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
    return Scaffold(backgroundColor: mainColor, body: content());
  }

  Widget content() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset("assets/animations/main.json"),
        Text(
          "BABY SHOP HUB",
          style: TextStyle(color: textColor, fontSize: 20),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Credits: @AbdJav",
              style: TextStyle(color: textColor),
            ),
          ),
        )
      ],
    );
  }
}
