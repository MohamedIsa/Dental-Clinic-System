import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../utils/popups.dart';

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
      await _firestore.collection('user').doc(currentUser.uid).set(
        {
          'Email': currentUser.email,
          'FullName': fullName,
          'CPR': cpr,
          'Phone': phone,
          'Gender': _selectedGender,
          'DOB': _dobTextController.text,
        },
        SetOptions(merge: true),
      );

      await _firestore.collection('patient').doc(currentUser.uid).set({
        'UID': currentUser.uid,
      });

      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => PatientHomePage(),
      //   ),
      // );
    } else {
      showErrorDialog(context, 'No user is currently signed in.');
    }
  } catch (e) {
    print('Failed to update user: $e');
    showErrorDialog(context, e.toString());
  }
}
