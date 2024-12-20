import 'package:flutter/material.dart';

import '../models/navbaritem.dart';

class TopNavBar extends StatelessWidget {
  final List<NavBarItem> navItems;
  const TopNavBar({super.key, required this.navItems});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: navItems.map((item) {
              return _buildNavButton(context, item.label, () {
                Navigator.pushNamed(context, item.route);
              });
            }).toList(),
          ),
        ],
      ),
    );
  }

  TextButton _buildNavButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}
