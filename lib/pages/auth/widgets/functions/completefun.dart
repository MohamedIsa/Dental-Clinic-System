import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../utils/popups.dart';
import '../../../../models/users.dart';

String cprPattern = r'^\d{2}(0[1-9]|1[0-2])\d{5}$';
String phonePattern = r'^(66\d{6}|3[2-9]\d{6})$';

Future<void> completeRegistration(
    BuildContext context,
    uid,
    _fullNameTextController,
    _cprTextController,
    _phoneTextController,
    _selectedGender,
    _dobTextController) async {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String fullName = _fullNameTextController.text;
  String cpr = _cprTextController.text;
  String phone = _phoneTextController.text;
  List<String> errors = [];

  if (fullName.isEmpty) {
    errors.add('Full Name is required.');
  }
  if (cpr.isEmpty) {
    errors.add('CPR is required.');
  }
  if (phone.isEmpty) {
    errors.add('Phone number is required.');
  }
  if (phone.isNotEmpty && !RegExp(phonePattern).hasMatch(phone)) {
    errors.add('Invalid phone number format.');
  }
  if (cpr.isNotEmpty && !RegExp(cprPattern).hasMatch(cpr)) {
    errors.add('Invalid CPR format.');
  }
  if (_dobTextController.text.isEmpty) {
    errors.add('Date of Birth is required.');
  }
  if (errors.isNotEmpty) {
    showErrorDialog(context, errors.join('\n'));
    return;
  }

  try {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      Users user = Users(
        id: currentUser.uid,
        name: fullName,
        email: currentUser.email!,
        role: 'patient',
        phone: phone,
        cpr: cpr,
        dob: _dobTextController.text,
        gender: _selectedGender,
      );

      await _firestore.collection('users').doc(currentUser.uid).set({
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'role': user.role,
        'phone': user.phone,
        'cpr': user.cpr,
        'gender': user.gender,
        'dob': user.dob,
      });

      Navigator.pushReplacementNamed(context, '/patientDashboard');
    } else {
      showErrorDialog(context, 'No user is currently signed in.');
    }
  } catch (e) {
    print('Failed to update user: $e');
    showErrorDialog(context, e.toString());
  }
}
