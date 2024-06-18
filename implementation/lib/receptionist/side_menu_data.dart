import 'package:senior/receptionist/side_menu_model.dart';
import 'package:flutter/material.dart';

class SideMenuData {
  final menu = const <MenuModel>[
    MenuModel(icon: Icons.home, title: 'Dashboard', routeName: '/receptionist'), 
    MenuModel(icon: Icons.calendar_month, title: 'Appointment', routeName: '/appointment_receptionist'),
    MenuModel(icon: Icons.group, title: 'Patients', routeName: '/patients_Receptionist'),
  ];
}

