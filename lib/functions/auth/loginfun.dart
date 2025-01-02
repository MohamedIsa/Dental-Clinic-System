import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:senior/utils/popups.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> login(
  BuildContext context,
  TextEditingController emailTextController,
  TextEditingController passwordTextController,
) async {
  String email = emailTextController.text;
  String password = passwordTextController.text;

  try {
    List<String> errors = [];
    if (email.isEmpty) {
      errors.add('Please enter your email');
    }
    if (password.isEmpty) {
      errors.add('Please enter your password');
    }
    if (errors.isNotEmpty) {
      showErrorDialog(context, errors.join('\n'));
      return;
    }

    QuerySnapshot emailCheck = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (emailCheck.docs.isEmpty) {
      showErrorDialog(context, 'Email not found. Please check and try again.');
      return;
    }

    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    if (userCredential.user != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userCredential.user!.uid);
      await navigateBasedOnUserRole(context, userCredential.user!.uid);
    }
  } catch (e) {
    showErrorDialog(context, 'Invalid password. Please try again.');
  }
}

Future<void> navigateBasedOnUserRole(
  BuildContext context,
  String userId,
) async {
  try {
    final roles = ['patient', 'admin', 'receptionist', 'dentist'];
    for (String role in roles) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists && snapshot['role'] == role) {
        switch (role) {
          case 'patient':
            Navigator.pushReplacementNamed(context, '/patientDashboard');
            return;
          case 'admin':
            Navigator.pushReplacementNamed(context, '/dashboard');
            return;
          case 'receptionist':
            Navigator.pushReplacementNamed(context, '/receptionist');
            return;
          case 'dentist':
            Navigator.pushReplacementNamed(context, '/dentist');
            return;
        }
      }
    }
    showErrorDialog(context, 'User role not found. Please contact support.');
  } catch (e) {
    showErrorDialog(context, 'Error determining user role. Please try again.');
  }
}
