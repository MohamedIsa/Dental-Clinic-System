import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void updateUser(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController cprController,
    TextEditingController dobController,
    String selectedGender,
    TextEditingController phoneController) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'name': nameController.text,
      'cpr': cprController.text,
      'dob': dobController.text,
      'gender': selectedGender,
      'phone': phoneController.text,
    });
    context.go('/patientDashboard');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('User updated successfully'),
    ));
  }
}
