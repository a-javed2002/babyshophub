import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/views/Chats/chats.dart';
import 'package:babyshophub/views/Profile/profile.dart';
import 'package:babyshophub/views/home/allProduct.dart';
import 'package:babyshophub/views/home/landingPage.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  PageController _pageController = PageController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          Container(
            child: LandingPage(context:context),
          ),
          Container(
            child: AllProductScreen(),
          ),
          Container(
            child: ChatListScreen(),
          ),
          Container(
            child: MyProfile(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        },
        backgroundColor: mainColor,
        selectedItemColor: textColor, // Set the selected item color
        unselectedItemColor: Colors.grey, // Set the unselected item color
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
            icon: Icon(Icons.chat),
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
