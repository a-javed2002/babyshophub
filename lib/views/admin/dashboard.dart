import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/controllers/auth_controller.dart';
import 'package:babyshophub/views/admin/category/add-category.dart';
import 'package:babyshophub/views/admin/category/show-category.dart';
import 'package:babyshophub/views/admin/product/add-product.dart';
import 'package:babyshophub/views/admin/product/show-product.dart';
import 'package:babyshophub/views/authentication/Login.dart';
import 'package:babyshophub/views/common/admin-scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyDashboard extends StatefulWidget {
  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  late AuthController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AuthController();
  }

  @override
  Widget build(BuildContext context) {
    return AdminCustomScaffold(
      context: context,
      appBarTitle: 'Dashboarde',
      body: Column(
        children: [
          Container(
            child: Center(
              child: Text('Welcome to the Dashboard'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                _controller.logout(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Signout'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                _controller.logout(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AddCategory()),
                );
              },
              child: Text('Add cat'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                _controller.logout(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AddProduct()),
                );
              },
              child: Text('Add pro'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                _controller.logout(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ShowProduct()),
                );
              },
              child: Text('Show pro'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                _controller.logout(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ShowCategory()),
                );
              },
              child: Text('Show cat'),
            ),
          ),
        ],
      ),
    );
  }
}
