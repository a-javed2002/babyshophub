import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/views/authentication/login.dart';
import 'package:babyshophub/views/home/home.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
      backgroundColor: mainColor,
      body: content()
    );
  }
  Widget content(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset("assets/animations/main.json"),
        Text("BABY SHOP HUB",style: TextStyle(color: textColor,fontSize: 20),)
      ],
    );
  }
}