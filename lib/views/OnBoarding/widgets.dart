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
    child: Center(
      child: Text("Page-1", style: TextStyle(color: Colors.white)),
    ),
  );
}

Widget IntroPage2() {
  return Container(
      color: Colors.red,
      child: Center(
        child: Text("Page-2"),
      ));
}

Widget IntroPage3() {
  return Container(
      color: Colors.green,
      child: Center(
        child: Text("Page-3"),
      ));
}
