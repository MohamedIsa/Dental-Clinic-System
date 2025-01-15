import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senior/utils/popups.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginfun.dart';

Future<void> checkUserLoggedIn(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userId = prefs.getString('userId');

  if (userId != null) {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (snapshot.exists) {
      String? role = snapshot.get('role');
      if (role != null) {
        await navigateBasedOnUserRole(context, userId);
      } else {
        showErrorDialog(context, 'Role not found for user');
      }
    } else {
      showErrorDialog(context, 'User not found');
    }
  } else {
    showErrorDialog(context, 'User not logged in');
  }
}

Future<void> persistUser(String userId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', userId);
}
