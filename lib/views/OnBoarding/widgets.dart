import 'package:lottie/lottie.dart';
import 'package:babyshophub/consts/consts.dart';
import 'package:flutter/material.dart';

Widget IntroPage1() {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          mainColor,
          mainLightColor,
          whiteColor,
        ],
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset("assets/animations/boost.json",height: 150,width: 150,reverse: true,repeat: true,fit: BoxFit.cover),
        SizedBox(height: 16), // Add some space between the image and text
        Text(
          "Heading for Page 1",
          style: TextStyle(
              color: whiteColor, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(height: 8), // Add some space between the heading and text
        Text(
          "Some text for Page 1.",
          style: TextStyle(color: whiteColor, fontSize: 16),
        ),
      ],
    ),
  );
}

Widget IntroPage2() {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          mainColor,
          mainLightColor,
          whiteColor,
        ],
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset("assets/animations/work.json",height: 150,width: 150,reverse: true,repeat: true,fit: BoxFit.cover),
        SizedBox(height: 16), // Add some space between the image and text
        Text(
          "Heading for Page 2",
          style: TextStyle(
              color: whiteColor, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(height: 8), // Add some space between the heading and text
        Text(
          "Some text for Page 2.",
          style: TextStyle(color: whiteColor, fontSize: 16),
        ),
      ],
    ),
  );
}

Widget IntroPage3() {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          mainColor,
          mainLightColor,
          whiteColor,
        ],
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset("assets/animations/achieve.json",height: 150,width: 150,reverse: true,repeat: true,fit: BoxFit.cover),
        SizedBox(height: 16), // Add some space between the image and text
        Text(
          "Heading for Page 3",
          style: TextStyle(
              color: whiteColor, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(height: 8), // Add some space between the heading and text
        Text(
          "Some text for Page 3.",
          style: TextStyle(color: whiteColor, fontSize: 16),
        ),
      ],
    ),
  );
}
