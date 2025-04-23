import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:senior/functions/auth/exists.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/popups.dart';
import 'completefun.dart';

Future<void> signUp(
  BuildContext context,
  TextEditingController emailTextController,
  TextEditingController passwordTextController,
  TextEditingController confirmPasswordTextController,
  TextEditingController fullNameTextController,
  TextEditingController cprTextController,
  TextEditingController phoneTextController,
  String selectedGender,
  TextEditingController dobTextController,
) async {
  try {
    List errors = [];
    if (await emailExists(emailTextController.text) == true) {
      errors.add('Email already exists');
    }
    if (await cprExists(cprTextController.text) == true) {
      errors.add('CPR already exists');
    }
    if (errors.isEmpty) {
      showErrorDialog(context, errors.join('\n'));
      return;
    }

    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailTextController.text,
      password: passwordTextController.text,
    );

    if (userCredential.user != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userCredential.user!.uid);

      await completeRegistration(
        context,
        userCredential.user!.uid,
        fullNameTextController,
        cprTextController,
        phoneTextController,
        selectedGender,
        dobTextController,
      );
    }
  } catch (e) {
    showErrorDialog(context, 'Failed to sign up');
  }
}
