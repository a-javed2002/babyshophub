import 'package:babyshophub/consts/colors.dart';
import 'package:babyshophub/controllers/auth_controller.dart';
import 'package:babyshophub/views/Chats/chats-details.dart';
import 'package:babyshophub/views/admin/category/add-category.dart';
import 'package:babyshophub/views/admin/category/show-category.dart';
import 'package:babyshophub/views/admin/dashboard.dart';
import 'package:babyshophub/views/admin/order/orders.dart';
import 'package:babyshophub/views/Chats/chats.dart';
import 'package:babyshophub/views/admin/product/add-product.dart';
import 'package:babyshophub/views/admin/product/show-product.dart';
import 'package:babyshophub/views/admin/profile.dart';
import 'package:babyshophub/views/admin/users.dart';
import 'package:babyshophub/views/authentication/Login.dart';
import 'package:babyshophub/views/common/appBar.dart';
import 'package:flutter/material.dart';

class AdminCustomScaffold extends StatefulWidget {
  bool bottom;
  bool cat;
  final Widget body;
  final String appBarTitle;
  final bool showDrawer;
  final BuildContext context;

  AdminCustomScaffold({
    this.bottom = false,
    this.cat = false,
    required this.body,
    required this.appBarTitle,
    this.showDrawer = true,
    required this.context,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.bottom
          ? widget.cat
              ? FloatingActionButton(
                  onPressed: () {
                    // Add your edit button functionality here
                    print('Edit Cat button pressed!');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddCategory()),
                    );
                  },
                  child: Icon(Icons.edit),
                )
              : FloatingActionButton(
                  onPressed: () {
                    // Add your edit button functionality here
                    print('Edit Product button pressed!');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddProduct()),
                    );
                  },
                  child: Icon(Icons.edit),
                )
          : Container(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // Adjust as needed
      appBar: CustomAppBar(
        title: widget.appBarTitle,
        backgroundColor: mainColor,
        // icons: [Icons.search, Icons.more_vert],
        // onPressed: [
        //   () {
        //     print("Search Clicked");
        //   },
        //   () {
        //     print("Vertical More Clicked");
        //   },
        // ],
      ),
      drawer: MyDrawer(),
      body: widget.body,
    );
  }
}

class MyDrawer extends StatelessWidget {
  late AuthController _controller = AuthController();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: mainColor,
            ),
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Baby Shop Hub",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 251, 249, 249),
                          fontSize: 24),
                    ),
                    Text(
                      "A Way To Ease",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyProfileAdmin()),
                    );
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipOval(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/profile.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          ListTile(
            title: const Text(
              "Dashboard",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onTap: () {
              print("Clicked On Add Category");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyDashboard()),
              );
            },
            leading: const Icon(Icons.home),
            horizontalTitleGap: 0,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
          ),
          ListTile(
            title: const Text(
              "Add Category",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onTap: () {
              print("Clicked On Add Category");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCategory()),
              );
            },
            leading: const Icon(Icons.add),
            horizontalTitleGap: 0,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
          ),
          ListTile(
            title: const Text(
              "Show Category",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onTap: () {
              print("Clicked On Show Category");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShowCategory()),
              );
            },
            leading: const Icon(Icons.document_scanner),
            horizontalTitleGap: 0,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
          ),
          ListTile(
            title: const Text(
              "Add Product",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onTap: () {
              print("Clicked On Add Product");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProduct()),
              );
            },
            leading: const Icon(Icons.add),
            horizontalTitleGap: 0,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
          ),
          ListTile(
            title: const Text(
              "Show Product",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onTap: () {
              print("Clicked On Show Product");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShowProduct()),
              );
            },
            leading: const Icon(Icons.document_scanner),
            horizontalTitleGap: 0,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
          ),
          ListTile(
            title: const Text(
              "Orders",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onTap: () {
              print("Clicked On Show Product");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrdersScreen()),
              );
            },
            leading: const Icon(Icons.document_scanner),
            horizontalTitleGap: 0,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
          ),
          ListTile(
            title: const Text(
              "Chats",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onTap: () {
              print("Clicked On Show Product");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatListScreen()),
              );
            },
            leading: const Icon(Icons.chat),
            horizontalTitleGap: 0,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
          ),
          ListTile(
            title: const Text(
              "users",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onTap: () {
              print("Clicked On Show Product");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyUsers()),
              );
            },
            leading: const Icon(Icons.person),
            horizontalTitleGap: 0,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
          ),
          // ListTile(
          //   title: const Text(
          //     "ChatsR",
          //     style: TextStyle(fontSize: 20, color: Colors.black),
          //   ),
          //   onTap: () {
          //     print("Clicked On Show Product");
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => ChatScreen(
          //                 currentUserUid: "4dwinBS5lVRMsNyeMLIUASIHFYs1",
          //                 recipientUid: "W61jBbxY3KY3JxL4wMdMeMIH9qr1",
          //               )),
          //     );
          //   },
          //   leading: const Icon(Icons.edit),
          //   horizontalTitleGap: 0,
          //   contentPadding: EdgeInsets.symmetric(horizontal: 16),
          // ),
          ListTile(
            // title: const Text("Logout",style: TextStyle(fontSize: 20),).onTap(() {Get.off(()=>const HomeScreen());}),
            title: const Text(
              "Logout",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onTap: () async {
              _controller.logout(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            leading: const Icon(Icons.logout),
            horizontalTitleGap: 0,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ],
      ),
    );
  }
}
