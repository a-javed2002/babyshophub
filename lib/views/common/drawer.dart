import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/views/Profile/profile.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {

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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyProfile()),
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
              "Home",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onTap: () {
              Navigator.pop(context);
            },
            leading: const Icon(Icons.home),
            horizontalTitleGap: 0,
          ),
          ListTile(
            title: const Text(
              "Settings",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onTap: () {
              Navigator.pop(context);
            },
            leading: const Icon(Icons.settings),
            horizontalTitleGap: 0,
          ),
          ListTile(
            // title: const Text("Logout",style: TextStyle(fontSize: 20),).onTap(() {Get.off(()=>const HomeScreen());}),
            title: const Text(
              "Logout",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onTap: () {
              Navigator.pop(context);
            },
            leading: const Icon(Icons.logout),
            horizontalTitleGap: 0,
          ),
        ],
      ),
    );
  }
}
