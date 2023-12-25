import 'package:flutter/material.dart';
import 'package:babyshophub/consts/colors.dart';

class CustomCheckBoxBtn extends StatefulWidget {
  final String title;

  CustomCheckBoxBtn({required this.title});

  @override
  _CustomCheckBoxBtnState createState() => _CustomCheckBoxBtnState();
}

class _CustomCheckBoxBtnState extends State<CustomCheckBoxBtn> {
  bool isButtonClicked = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() {
          isButtonClicked = !isButtonClicked;
        });
      },
      child: Text(
        widget.title,
        style: TextStyle(
          color: isButtonClicked ? Colors.white : Colors.black,
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: isButtonClicked ? mainColor : Colors.transparent,
        padding: EdgeInsets.all(16.0),
      ),
    );
  }
}
