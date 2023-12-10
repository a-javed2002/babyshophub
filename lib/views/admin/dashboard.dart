import 'package:babyshophub/controllers/auth_controller.dart';
import 'package:babyshophub/views/admin/category/add-category.dart';
import 'package:babyshophub/views/authentication/Login.dart';
import 'package:babyshophub/views/common/admin-scaffold.dart';
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
          )
        ],
      ),
    );
  }
}
