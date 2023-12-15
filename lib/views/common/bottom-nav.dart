import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatefulWidget {
  const CustomBottomNavigation({
    Key? key,
    required this.onTabSelected,
    required this.selectedIndex,
    required this.items,
  }) : super(key: key);

  final ValueChanged<int> onTabSelected;
  final int selectedIndex;
  final List<BottomNavigationItem> items;

  @override
  _CustomBottomNavigationState createState() =>
      _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              widget.items.length,
              (index) {
                return buildNavItem(
                  index: index,
                  icon: widget.items[index].icon,
                  text: widget.items[index].text,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildNavItem({required int index, required IconData icon, required String text}) {
    final isSelected = index == widget.selectedIndex;
    final color = isSelected ? Colors.blue : Colors.grey;

    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onTabSelected(index),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color),
              SizedBox(height: 4),
              Text(
                text,
                style: TextStyle(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavigationItem {
  final IconData icon;
  final String text;

  BottomNavigationItem({required this.icon, required this.text});
}
