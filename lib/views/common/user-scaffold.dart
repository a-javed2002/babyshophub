import 'package:babyshophub/consts/colors.dart';
import 'package:babyshophub/views/Product/cart.dart';
import 'package:babyshophub/views/Product/wishlist.dart';
import 'package:babyshophub/views/common/appBar.dart';
import 'package:babyshophub/views/common/drawer.dart';
import 'package:flutter/material.dart';

class UserCustomScaffold extends StatefulWidget {
  final Widget body;
  final String appBarTitle;

  UserCustomScaffold({
    required this.body,
    required this.appBarTitle,
  });

  @override
  _UserCustomScaffoldState createState() => _UserCustomScaffoldState();
}

class _UserCustomScaffoldState extends State<UserCustomScaffold> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.appBarTitle,
        backgroundColor: mainColor,
        icons: [Icons.shopping_cart, Icons.favorite],
        onPressed: [
          () {
            print("CartScreen Clicked");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartScreen()),
            );
          },
          () {
            print("WishlistScreen Clicked");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WishlistScreen()),
            );
          },
        ],
      ),
      body: widget.body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
