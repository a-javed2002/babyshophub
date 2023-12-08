import 'package:babyshophub/consts/colors.dart';
import 'package:babyshophub/views/Profile/profile.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final List<DrawerItem> drawerItems;

  MyDrawer({required this.drawerItems});

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
                        fontSize: 24,
                      ),
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
                      MaterialPageRoute(builder: (context) => MyProfile()),
                    );
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            AssetImage("assets/images/profile.jpg"),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          ...drawerItems.map((item) => _buildDrawerItem(context, item)).toList(),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, DrawerItem item) {
    return ListTile(
      title: Text(
        item.title,
        style: TextStyle(
          fontSize: 20,
          color: item.isSelected ? Colors.blue : Colors.black,
        ),
      ),
      onTap: () {
        item.onTap(context); // Pass the context here
        Navigator.pop(context); // Close the drawer after tapping an item
      },
      leading: Icon(item.icon),
      horizontalTitleGap: 0,
    );
  }
}

class DrawerItem {
  final IconData icon;
  final String title;
  final Function(BuildContext) onTap;
  final bool isSelected;

  DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isSelected = false,
  });
}
