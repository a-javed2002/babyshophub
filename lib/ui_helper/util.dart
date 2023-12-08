import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

TextStyle mTextStyle11() {
  return TextStyle(fontSize: 11, color: Color.fromARGB(255, 112, 42, 233));
}

TextStyle mTextStyle12(
    {Color c = Colors.teal, FontWeight w = FontWeight.bold}) {
  return TextStyle(
    fontSize: 22,
    color: c,
    fontWeight: w,
  );
}
