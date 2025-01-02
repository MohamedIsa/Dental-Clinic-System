import 'package:flutter/material.dart';
import '../models/navbaritem.dart';
import 'app_colors.dart';

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
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: Colors.grey,
      unselectedLabelStyle: const TextStyle(color: Colors.grey),
      selectedLabelStyle: const TextStyle(color: AppColors.primaryColor),
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
