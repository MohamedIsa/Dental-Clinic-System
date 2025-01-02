import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:senior/utils/popups.dart';
import '../../../../models/side_menu_model.dart';

class SideMenuData {
  final menu = <MenuModel>[];

  Future<void> loadMenu(BuildContext context) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        return showErrorDialog(context, "User not logged in");
      }

      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final role = userDoc['role'];

      if (role == 'admin' || role == 'receptionist' || role == 'dentist') {
        menu.add(MenuModel(
            icon: Icons.home, title: 'Dashboard', routeName: '/dashboard'));
      }
      if (role == 'admin' || role == 'receptionist') {
        menu.add(MenuModel(
            icon: Icons.calendar_month,
            title: 'Appointment',
            routeName: '/appointment'));
        menu.add(MenuModel(
            icon: Icons.group, title: 'Patients', routeName: '/patients'));
      }
      if (role == 'admin') {
        menu.add(MenuModel(
            icon: Icons.settings, title: 'Settings', routeName: '/settings'));
      }
      if (role == 'dentist') {
        menu.add(MenuModel(
            icon: Icons.receipt_rounded,
            title: 'Treatment Records',
            routeName: '/treatment'));
        menu.add(MenuModel(
            icon: Icons.group,
            title: 'Patients',
            routeName: '/patients_dentist'));
      }
    } catch (e) {
      showErrorDialog(context, "An error occurred: $e");
    }
  }
}
