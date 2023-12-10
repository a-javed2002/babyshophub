import 'package:babyshophub/views/common/admin-scaffold.dart';
import 'package:flutter/material.dart';

class ShowProduct extends StatefulWidget {
  const ShowProduct({super.key});

  @override
  State<ShowProduct> createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  @override
  Widget build(BuildContext context) {
    return AdminCustomScaffold(
      appBarTitle: "Add Product",
      body: Center(
        child: Text("Show Product"),
      ),
      );
  }
}