import 'package:flutter/material.dart';
import 'package:babyshophub/consts/colors.dart';

class SmoothDropdown extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final ValueChanged<String> onItemSelected;
  String selectedValue;

  SmoothDropdown({
    Key? key,
    required this.title,
    required this.items,
    required this.onItemSelected,
    required this.selectedValue,
  }) : super(key: key);

  @override
  _SmoothDropdownState createState() => _SmoothDropdownState();
}

class _SmoothDropdownState extends State<SmoothDropdown> {
  @override
  void initState() {
    super.initState();
    // Set the default selected value to the first item in the list
    widget.selectedValue == "" ? widget.selectedValue = widget.items.first["id"] : "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded:
                      true, // Set to true to allow the dropdown to take up available width
                  value: widget.selectedValue,
                  onChanged: (newValue) {
                    setState(() {
                      widget.selectedValue = newValue!;
                      print('Selected value: ${widget.selectedValue}');
                      // Call the callback with the selected value
                      widget.onItemSelected(widget.selectedValue);
                    });
                  },
                  items: widget.items.map((item) {
                    return DropdownMenuItem<String>(
                      value: item["id"],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item["name"],
                              style: item["id"] == widget.selectedValue
                                  ? TextStyle(
                                      color: whiteColor,
                                      backgroundColor: mainColor)
                                  : TextStyle(),
                              overflow: TextOverflow
                                  .ellipsis, // Specify the overflow behavior
                              maxLines:
                                  5, // Limit to one line to prevent vertical overflow
                            ),
                          ),
                          const Divider(
                            height:
                                1, // Adjust the height of the divider as needed
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
