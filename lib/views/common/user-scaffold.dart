import 'package:babyshophub/consts/colors.dart';
import 'package:babyshophub/views/common/appBar.dart';
import 'package:babyshophub/views/common/drawer.dart';
import 'package:flutter/material.dart';

class UserCustomScaffold extends StatelessWidget {
  final Widget body;
  final String appBarTitle;

  UserCustomScaffold({
    required this.body,
    required this.appBarTitle,
  });

  List<DrawerItem> _buildDrawerItems(BuildContext context) {
    // Customize this method to generate dynamic drawer items based on the context or any other logic.
    return [
      DrawerItem(icon: Icons.home, title: 'Home', onTap: (context) { /* Handle Home tap */ }),
      DrawerItem(icon: Icons.settings, title: 'Settings', onTap: (context) { /* Handle Settings tap */ }),
      // Add more items as needed
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<DrawerItem> drawerItems = _buildDrawerItems(context);

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
      drawer: MyDrawer(drawerItems:  drawerItems),
      body: body,
    );
  }
}
