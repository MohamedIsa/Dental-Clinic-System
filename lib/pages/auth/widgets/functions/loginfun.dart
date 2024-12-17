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
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailTextController.text,
      password: _passwordTextController.text,
    );

    if (userCredential.user != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userCredential.user!.uid);
      await _navigateBasedOnUserRole(context, userCredential.user!.uid);
    }
  } catch (e) {
    _handleLoginError(
      context,
      _emailTextController,
      _passwordTextController,
    );
  }
}

Future<void> _navigateBasedOnUserRole(
    BuildContext context, String userId) async {
  final roles = ['patient', 'admin', 'receptionist', 'dentist'];

  for (String role in roles) {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection(role).doc(userId).get();

    if (snapshot.exists) {
      switch (role) {
        case 'patient':
          Navigator.pushNamed(context, '/dashboard');
          return;
        case 'admin':
          Navigator.pushNamed(context, '/admin');
          return;
        case 'receptionist':
          Navigator.pushNamed(context, '/receptionist');
          return;
        case 'dentist':
          Navigator.pushNamed(context, '/dentist');
          return;
      }
    }
  }

  showErrorDialog(context, 'User not found');
}

void _handleLoginError(
  BuildContext context,
  TextEditingController _emailTextController,
  TextEditingController _passwordTextController,
) {
  if (_emailTextController.text.isEmpty ||
      _passwordTextController.text.isEmpty) {
    showErrorDialog(context, 'Please fill all the fields');
  } else {
    showErrorDialog(context, 'Invalid email or password');
  }
}
