import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/popups.dart';
import '../../models/users.dart';
import 'exists.dart';

Future<void> completeRegistration(
    BuildContext context,
    uid,
    TextEditingController fullNameTextController,
    TextEditingController cprTextController,
    TextEditingController phoneTextController,
    String selectedGender,
    TextEditingController dobTextController) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String fullName = fullNameTextController.text;
  String cpr = cprTextController.text;
  String phone = phoneTextController.text;
  String dob = dobTextController.text;

  try {
    if (await cprExists(cpr) == true) {
      showErrorDialog(context, 'CPR already exists');
      return;
    }
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
      await firestore
          .collection('users')
          .doc(currentUser.uid)
          .set(user.toFirestore());

      context.go('/patientDashboard');
    }
  } catch (e) {
    if (context.mounted) {
      showErrorDialog(context, e.toString());
    }
  }
}
