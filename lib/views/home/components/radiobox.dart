import 'package:flutter/material.dart';
import 'package:babyshophub/consts/colors.dart';

class CustomRadioBoxBtn extends StatefulWidget {
  final List<String> options;
  final bool selectFirstOption;

  CustomRadioBoxBtn({required this.options, this.selectFirstOption = false});

  @override
  _CustomRadioBoxBtnState createState() => _CustomRadioBoxBtnState();
}

class _CustomRadioBoxBtnState extends State<CustomRadioBoxBtn> {
  late String selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.selectFirstOption ? widget.options.first : '';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (String option in widget.options)
          GestureDetector(
            onTap: () {
              setState(() {
                selectedOption = option;
                print('Selected option: $selectedOption');
              });
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.symmetric(vertical: 8.0),
              color: selectedOption == option ? mainColor : Colors.transparent,
              child: Text(
                option,
                style: TextStyle(
                  color: selectedOption == option ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
