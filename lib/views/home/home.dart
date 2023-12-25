import 'package:animate_do/animate_do.dart';
import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/controllers/auth_controller.dart';
import 'package:babyshophub/views/Product/cart.dart';
import 'package:babyshophub/views/Product/category.dart';
import 'package:babyshophub/views/Product/product-details.dart';
import 'package:babyshophub/views/Product/wishlist.dart';
import 'package:babyshophub/views/Profile/profile.dart';
import 'package:babyshophub/views/home/allProduct.dart';
import 'package:babyshophub/views/home/landingPage.dart';
import 'package:babyshophub/views/orders/orders.dart';
import 'package:babyshophub/views/authentication/login.dart';
import 'package:babyshophub/views/common/user-scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             FadeInUp(
//                 duration: Duration(milliseconds: 1000),
//                 child: Container(
//                   height: 500,
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                           image: AssetImage('assets/images/background.jpg'),
//                           fit: BoxFit.cover)),
//                   child: Container(
//                     decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                             begin: Alignment.bottomRight,
//                             colors: [
//                           Colors.black.withOpacity(.8),
//                           Colors.black.withOpacity(.2),
//                         ])),
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 50.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: <Widget>[
//                               FadeInUp(
//                                   duration: Duration(milliseconds: 1200),
//                                   child: IconButton(
//                                     icon: Icon(
//                                       Icons.favorite,
//                                       color: Colors.white,
//                                     ),
//                                     onPressed: () {},
//                                   )),
//                               FadeInUp(
//                                   duration: Duration(milliseconds: 1300),
//                                   child: IconButton(
//                                     icon: Icon(
//                                       Icons.shopping_cart,
//                                       color: Colors.white,
//                                     ),
//                                     onPressed: () {},
//                                   )),
//                             ],
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(20.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 FadeInUp(
//                                     duration: Duration(milliseconds: 1500),
//                                     child: Text(
//                                       "Our New Products",
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 30,
//                                           fontWeight: FontWeight.bold),
//                                     )),
//                                 SizedBox(
//                                   height: 15,
//                                 ),
//                                 FadeInUp(
//                                     duration: Duration(milliseconds: 1700),
//                                     child: Row(
//                                       children: <Widget>[
//                                         Text(
//                                           "VIEW MORE",
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w600),
//                                         ),
//                                         SizedBox(
//                                           width: 5,
//                                         ),
//                                         Icon(
//                                           Icons.arrow_forward_ios,
//                                           color: Colors.white,
//                                           size: 15,
//                                         )
//                                       ],
//                                     ))
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 )),
//             FadeInUp(
//                 duration: Duration(milliseconds: 1400),
//                 child: Container(
//                   padding: EdgeInsets.all(20),
//                   child: Column(
//                     children: <Widget>[
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Text(
//                             "Categories",
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           Text("All")
//                         ],
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       CategorySlider(),
//                       ProductSlider(),
//                       Center(
//                         child: ElevatedButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => CartScreen(),
//                                 ),
//                               );
//                             },
//                             child: Text("Cart")),
//                       ),
//                       Center(
//                         child: ElevatedButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => WishlistScreen(),
//                                 ),
//                               );
//                             },
//                             child: Text("Wishlist")),
//                       ),
//                       Center(
//                         child: ElevatedButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => OrdersScreen(),
//                                 ),
//                               );
//                             },
//                             child: Text("orders")),
//                       ),
//                     ],
//                   ),
//                 ))
//           ],
//         ),
//       ),
//     );
//   }
// }


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
            child: WishlistScreen(),
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
