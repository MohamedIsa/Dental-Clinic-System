import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:senior/utils/popups.dart';
import 'checkuserloggedin.dart';
import 'exists.dart';

Future<void> login(
  BuildContext context,
  TextEditingController emailTextController,
  TextEditingController passwordTextController,
) async {
  String email = emailTextController.text;
  String password = passwordTextController.text;

  try {
    if (await emailExists(email) == false) {
      showErrorDialog(context, 'Email not found. Please check and try again.');
      return;
    }
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    if (userCredential.user != null) {
      await persistUser(userCredential.user!.uid);
      await navigateBasedOnUserRole(context, userCredential.user!.uid);
    }
  } catch (e) {
    showErrorDialog(context, '${e.toString()})');
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
            context.go('/patientDashboard');
            return;
          case 'admin':
            context.go('/dashboard');
            return;
          case 'receptionist':
            context.go('/dashboard');
            return;
          case 'dentist':
            context.go('/dashboard');
            return;
        }
      }
    }
    showErrorDialog(context, 'User role not found. Please contact support.');
  } catch (e) {
    showErrorDialog(context, 'Error determining user role. Please try again.');
  }
}
