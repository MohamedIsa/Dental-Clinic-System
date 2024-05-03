import 'package:adminpage/models/side_menu_model.dart';
import 'package:flutter/material.dart';

class SideMenuData {
  final menu = const <MenuModel>[
    MenuModel(icon: Icons.home, title: 'Dashboard', routeName: '/dashboard'), 
    MenuModel(icon: Icons.calendar_month, title: 'Appointment', routeName: '/appointment'),
    MenuModel(icon: Icons.group, title: 'Patients', routeName: '/patients'),
    MenuModel(icon: Icons.receipt_rounded, title: 'Treatment Records', routeName: '/treatment'),
    MenuModel(icon: Icons.summarize, title: 'Reports', routeName: '/reports'),
    MenuModel(icon: Icons.settings, title: 'Settings', routeName: '/settings'),
  ];
}

