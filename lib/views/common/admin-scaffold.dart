import 'package:babyshophub/consts/colors.dart';
import 'package:babyshophub/controllers/auth_controller.dart';
import 'package:babyshophub/views/admin/category/add-category.dart';
import 'package:babyshophub/views/admin/category/show-category.dart';
import 'package:babyshophub/views/admin/product/add-product.dart';
import 'package:babyshophub/views/admin/product/show-product.dart';
import 'package:babyshophub/views/authentication/Login.dart';
import 'package:babyshophub/views/common/appBar.dart';
import 'package:babyshophub/views/common/drawer.dart';
import 'package:flutter/material.dart';

class AdminCustomScaffold extends StatefulWidget {
  final Widget body;
  final String appBarTitle;

  AdminCustomScaffold({
    required this.body,
    required this.appBarTitle,
  });

  @override
  State<AdminCustomScaffold> createState() => _AdminCustomScaffoldState();
}

class _AdminCustomScaffoldState extends State<AdminCustomScaffold> {
  late AuthController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AuthController();
  }

  List<DrawerItem> _buildDrawerItems(BuildContext context) {
    // Customize this method to generate dynamic drawer items based on the context or any other logic.
    return [
      DrawerItem(
          isSelected: true,
          icon: Icons.home,
          title: 'Dashboard',
          onTap: (context) {
            print("Clicked On Dashboard");
          }),
      DrawerItem(
          icon: Icons.settings,
          title: 'Add Category',
          onTap: (context) {
            print("Clicked On Add Category");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddCategory()),
            );
          }),
      DrawerItem(
          icon: Icons.settings,
          title: 'Show Category',
          onTap: (context) {
            print("Clicked On Show Category");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShowCategory()),
            );
          }),
      DrawerItem(
          icon: Icons.settings,
          title: 'Add product',
          onTap: (context) {
            print("Clicked On Add Product");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddProduct()),
            );
          }),
      DrawerItem(
          icon: Icons.settings,
          title: 'Show Product',
          onTap: (context) {
            print("Clicked On Show Product");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShowProduct()),
            );
          }),
      DrawerItem(
          icon: Icons.settings,
          title: 'Settings',
          onTap: (context) {
            print("Clicked On Settings");
          }),
      DrawerItem(
          icon: Icons.settings,
          title: 'Logout',
          onTap: (context) async {
            print("Clicked On Logout");
            _controller.logout(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<DrawerItem> drawerItems = _buildDrawerItems(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.appBarTitle,
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
      body: widget.body,
    );
  }
}
