import 'package:babyshophub/views/common/admin-scaffold.dart';
import 'package:flutter/material.dart';

class ShowCategory extends StatefulWidget {
  const ShowCategory({super.key});

  @override
  State<ShowCategory> createState() => _ShowCategoryState();
}

class _ShowCategoryState extends State<ShowCategory> {
  @override
  Widget build(BuildContext context) {
    return AdminCustomScaffold(
      appBarTitle: "Add Category",
      body: Center(
        child: Text("Show Category"),
      ),
      );
  }
}