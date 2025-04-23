import 'package:flutter/material.dart';
import 'package:senior/functions/auth/completefun.dart';
import 'package:senior/functions/auth/signupfun.dart';
import '../createfaculty/adduser.dart';

Future<void> check({
  String? uid,
  required BuildContext context,
  TextEditingController? emailTextController,
  TextEditingController? passwordTextController,
  TextEditingController? confirmPasswordTextController,
  required TextEditingController fullNameTextController,
  required TextEditingController cprTextController,
  required TextEditingController phoneTextController,
  required String selectedGender,
  required TextEditingController dobTextController,
  String? selectedrole,
  Color? selectedColor,
}) async {
  if (uid == null && selectedrole == null) {
    await signUp(
      context,
      emailTextController!,
      passwordTextController!,
      confirmPasswordTextController!,
      fullNameTextController,
      cprTextController,
      phoneTextController,
      selectedGender,
      dobTextController,
    );
  }

  if (passwordTextController == null && selectedrole != null) {
    await adduser(
      context,
      fullNameTextController,
      emailTextController!,
      cprTextController,
      phoneTextController,
      selectedGender,
      dobTextController,
      selectedrole,
      selectedColor,
    );
  }

  if (uid != null) {
    await completeRegistration(
      context,
      uid,
      fullNameTextController,
      cprTextController,
      phoneTextController,
      selectedGender,
      dobTextController,
    );
  }
}
