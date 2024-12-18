import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:senior/utils/popups.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> login(
  BuildContext context,
  TextEditingController _emailTextController,
  TextEditingController _passwordTextController,
) async {
  try {
    List<String> errors = [];
    String email = _emailTextController.text.trim();
    String password = _passwordTextController.text.trim();

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

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userCredential.user!.uid);
      await _navigateBasedOnUserRole(context, userCredential.user!.uid);
    }
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'user-not-found':
        showErrorDialog(context, 'No user found for that email.');
        break;
      case 'wrong-password':
        showErrorDialog(context, 'Wrong password provided.');
        break;
      case 'invalid-email':
        showErrorDialog(context, 'Invalid email address.');
        break;
      case 'user-disabled':
        showErrorDialog(context, 'This user account has been disabled.');
        break;
      default:
        showErrorDialog(context, 'Authentication error: ${e.message}');
    }
  } catch (e) {
    showErrorDialog(context, 'An unexpected error occurred. Please try again.');
  }
}

Future<void> _navigateBasedOnUserRole(
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
            Navigator.pushReplacementNamed(context, '/admin');
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
