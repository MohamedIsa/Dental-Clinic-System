import 'package:flutter/material.dart';

class NavBarItem {
  final IconData icon;
  final String label;
  final String route;

  const NavBarItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
