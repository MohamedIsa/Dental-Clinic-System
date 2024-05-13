import 'package:senior/dentist/side_menu_model.dart';
import 'package:flutter/material.dart';

class SideMenuData {
  final menu = const <MenuModel>[
    MenuModel(icon: Icons.home, title: 'Dashboard', routeName: '/dentist'), 
    MenuModel(icon: Icons.group, title: 'Patients', routeName: '/patients_dentist'),
    MenuModel(icon: Icons.receipt_rounded, title: 'Treatment Records', routeName: '/treatment'),
  ];
}

