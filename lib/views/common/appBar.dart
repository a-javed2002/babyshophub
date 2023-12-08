import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final List<IconData?>? icons;
  final List<Function?>? onPressed;

  CustomAppBar({
    required this.title,
    required this.backgroundColor,
    this.icons,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      title: Text(
        title,
        style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
      ),
      actions: _buildActions(),
    );
  }

  List<Widget> _buildActions() {
    List<Widget> actions = [];
    if (icons != null && onPressed != null) {
      for (int i = 0; i < icons!.length; i++) {
        if (icons![i] != null && onPressed![i] != null) {
          actions.add(
            IconButton(
              icon: Icon(icons![i]),
              onPressed: () {
                onPressed![i]!();
              },
            ),
          );
        }
      }
    }
    return actions;
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
