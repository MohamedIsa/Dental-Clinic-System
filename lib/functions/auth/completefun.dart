import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/popups.dart';
import '../../models/users.dart';

String cprPattern = r'^\d{2}(0[1-9]|1[0-2])\d{5}$';
String phonePattern = r'^(66\d{6}|3[2-9]\d{6})$';
String dobPattern = r'^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/\d{4}$';

Future<void> completeRegistration(
    BuildContext context,
    uid,
    fullNameTextController,
    cprTextController,
    phoneTextController,
    selectedGender,
    dobTextController) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String fullName = fullNameTextController.text;
  String cpr = cprTextController.text;
  String phone = phoneTextController.text;
  String dob = dobTextController.text;
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
  if (dob.isEmpty) {
    errors.add('Date of Birth is required.');
  }
  if (dob.isNotEmpty && !RegExp(dobPattern).hasMatch(dob)) {
    errors.add('Invalid Date of Birth format');
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
        dob: dobTextController.text,
        gender: selectedGender,
      );

      await firestore.collection('users').doc(currentUser.uid).set({
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'role': user.role,
        'phone': user.phone,
        'cpr': user.cpr,
        'gender': user.gender,
        'dob': user.dob,
      });

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/patientDashboard');
      }
    } else {
      showErrorDialog(context, 'No user is currently signed in.');
    }
  } catch (e) {
    debugPrint('Failed to update user: $e');
    if (context.mounted) {
      showErrorDialog(context, e.toString());
    }
  }
}
