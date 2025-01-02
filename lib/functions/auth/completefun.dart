import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/popups.dart';
import '../../models/users.dart';

Future<void> completeRegistration(
    BuildContext context,
    uid,
    TextEditingController fullNameTextController,
    TextEditingController cprTextController,
    TextEditingController phoneTextController,
    String selectedGender,
    TextEditingController dobTextController) async {
  print("Entering complete function");
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String fullName = fullNameTextController.text;
  String cpr = cprTextController.text;
  String phone = phoneTextController.text;
  String dob = dobTextController.text;

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
        dob: dob,
        gender: selectedGender,
      );

      print('User ID: ${user.id}');
      print('Full Name: ${user.name}');
      print('Email: ${user.email}');
      print('Role: ${user.role}');
      print('Phone: ${user.phone}');
      print('CPR: ${user.cpr}');
      print('DOB: ${user.dob}');
      print('Gender: ${user.gender}');

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

      Navigator.pushReplacementNamed(context, '/patientDashboard');
    }
  } catch (e) {
    debugPrint('Failed to update user: $e');
    if (context.mounted) {
      showErrorDialog(context, e.toString());
    }
  }
}
