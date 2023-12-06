import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:babyshophub/views/authentication/login.dart';
import 'package:babyshophub/views/home/home.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              child: FlareActor(
                'assets/flare/baby_shop.flr',
                animation: 'idle',
              ),
            ),
            SizedBox(height: 20),
            TyperAnimatedTextKit(
              isRepeatingAnimation: false,
              text: ['BabyShopHub'],
              textStyle: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}