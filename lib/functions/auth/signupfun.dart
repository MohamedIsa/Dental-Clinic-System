import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  print("Entering signup function");
  try {
    print("Entering try signup");
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
