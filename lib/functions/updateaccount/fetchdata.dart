import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void fetchUserData(
    TextEditingController nameController,
    TextEditingController cprController,
    TextEditingController dobController,
    TextEditingController selectedGender,
    TextEditingController phoneController) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    nameController.text = snapshot['name'] ?? '';
    cprController.text = snapshot['cpr'] ?? '';
    dobController.text = snapshot['dob'] ?? '';
    selectedGender.text = snapshot['gender'] ?? '';
    phoneController.text = snapshot['phone'] ?? '';
  }
}
