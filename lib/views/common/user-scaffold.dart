import 'package:babyshophub/consts/colors.dart';
import 'package:babyshophub/views/common/appBar.dart';
import 'package:babyshophub/views/common/drawer.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final List<DrawerItem> drawerItems;
  final String appBarTitle;

  CustomScaffold({
    required this.body,
    required this.appBarTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: appBarTitle,
        backgroundColor: mainColor,
        icons: [Icons.search, Icons.more_vert],
        onPressed: [
          () {
            print("Search Clicked");
          },
          () {
            print("Vertical More Clicked");
          },
        ],
      ),
      drawer: MyDrawer(drawerItems: drawerItems),
      body: body,
    );
  }
}
