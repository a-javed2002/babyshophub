import 'package:flutter/material.dart';

class CustomRadioBoxBtn extends StatefulWidget {
  final List<String> options;
  final bool selectFirstOption;
  final void Function(String selectedValue) onPressed;

  CustomRadioBoxBtn({
    required this.options,
    this.selectFirstOption = false,
    required this.onPressed,
  });

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
                widget.onPressed(selectedOption); // Call the callback with the selected value
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  color: selectedOption == option ? Colors.blue : Colors.transparent,
                  child: Text(
                    option,
                    style: TextStyle(
                      color: selectedOption == option ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
