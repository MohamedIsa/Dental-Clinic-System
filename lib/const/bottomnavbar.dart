import 'package:flutter/material.dart';
import '../models/navbaritem.dart';

class BottomNavBar extends StatefulWidget {
  final List<NavBarItem> navItems;
  BottomNavBar({super.key, required this.navItems});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      unselectedLabelStyle: const TextStyle(color: Colors.grey),
      selectedLabelStyle: const TextStyle(color: Colors.blue),
      showUnselectedLabels: true,
      currentIndex: _selectedIndex,
      items: widget.navItems
          .map((item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.label,
              ))
          .toList(),
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });

        if (widget.navItems[index].route != '/') {
          Navigator.pushNamed(context, widget.navItems[index].route);
        }
      },
    );
  }
}
