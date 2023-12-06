import 'package:flutter/material.dart';

class CustomPopup extends StatelessWidget {
  final String message;
  final bool isSuccess;

  CustomPopup({required this.message, required this.isSuccess});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isSuccess ? 'Success' : 'Error'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}


// showDialog(
//   context: context,
//   builder: (BuildContext context) {
//     return CustomPopup(
//       message: 'Operation successful!',
//       isSuccess: true,
//     );
//   },
// );