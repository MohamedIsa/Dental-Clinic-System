import 'package:flutter/material.dart';
import 'package:senior/functions/auth/completefun.dart';
import 'package:senior/functions/auth/signupfun.dart';
import 'package:senior/utils/popups.dart';
import 'patterns.dart';

void check(
    BuildContext context,
    String? uid,
    TextEditingController? emailTextController,
    TextEditingController? passwordTextController,
    TextEditingController? confirmPasswordTextController,
    TextEditingController fullNameTextController,
    TextEditingController cprTextController,
    TextEditingController phoneTextController,
    String selectedGender,
    TextEditingController dobTextController) {
  String email = emailTextController!.text;
  String password = passwordTextController!.text;
  String confirmPassword = confirmPasswordTextController!.text;
  String fullName = fullNameTextController.text;
  String cpr = cprTextController.text;
  String phone = phoneTextController.text;
  String dob = dobTextController.text;
  List<String> errors = [];
  if (uid == null) {
    if (email.isEmpty) {
      errors.add('Email is required');
    } else if (!RegExp(Patterns.emailPattern).hasMatch(email)) {
      errors.add('Invalid email format.');
    }
  }
  if (uid == null) {
    if (password.isEmpty) {
      errors.add('Password is required');
    } else {
      final List<String> passwordErrors = [];

      if (password.length < 6) {
        passwordErrors.add('At least 6 characters');
      }

      if (!RegExp(Patterns.upperCase).hasMatch(password)) {
        passwordErrors.add('At least one uppercase letter');
      }

      if (!RegExp(Patterns.lowerCase).hasMatch(password)) {
        passwordErrors.add('At least one lowercase letter');
      }

      if (!RegExp(Patterns.specialCharacters).hasMatch(password)) {
        passwordErrors.add('At least one special character');
      }

      if (passwordErrors.isNotEmpty) {
        errors.add('Password must contain: ${passwordErrors.join(', ')}.');
      }
    }

    if (confirmPassword.isEmpty) {
      errors.add('Confirm Password is required');
    } else if (password != confirmPassword) {
      errors.add('Passwords do not match');
    }
  }
  if (fullName.isEmpty) {
    errors.add('Full Name is required.');
  }
  if (cpr.isEmpty) {
    errors.add('CPR is required.');
  }
  if (phone.isEmpty) {
    errors.add('Phone number is required.');
  }
  if (phone.isNotEmpty && !RegExp(Patterns.phonePattern).hasMatch(phone)) {
    errors.add('Invalid phone number format.');
  }
  if (cpr.isNotEmpty && !RegExp(Patterns.cprPattern).hasMatch(cpr)) {
    errors.add('Invalid CPR format.');
  }
  if (dob.isEmpty) {
    errors.add('Date of Birth is required.');
  }
  if (dob.isNotEmpty && !RegExp(Patterns.dobPattern).hasMatch(dob)) {
    errors.add('Invalid Date of Birth format');
  }
  if (errors.isNotEmpty) {
    showErrorDialog(context, errors.join('\n'));
    return;
  }

  errors.isEmpty && uid == null
      ? signUp(
          context,
          emailTextController,
          passwordTextController,
          confirmPasswordTextController,
          fullNameTextController,
          cprTextController,
          phoneTextController,
          selectedGender,
          dobTextController)
      : completeRegistration(
          context,
          uid,
          fullNameTextController,
          cprTextController,
          phoneTextController,
          selectedGender,
          dobTextController);
}
