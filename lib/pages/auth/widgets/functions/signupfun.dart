import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/popups.dart';
import 'completefun.dart';

String emailPattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
String cprPattern = r'^\d{2}(0[1-9]|1[0-2])\d{5}$';
String phonePattern = r'^(66\d{6}|3[2-9]\d{6})$';
String passwordPattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$';
String specialCharacters = '[!@#\$%^&*()_+\-=\\[\\]{};:\'",.<>?/\\\\|`~]';
String upperCase = r'^(?=.*[A-Z])';
String lowerCase = r'^(?=.*[a-z])';

Future<void> signUp(
  BuildContext context,
  TextEditingController _emailTextController,
  TextEditingController _passwordTextController,
  TextEditingController _confirmPasswordTextController,
  TextEditingController _fullNameTextController,
  TextEditingController _cprTextController,
  TextEditingController _phoneTextController,
  String _selectedGender,
  TextEditingController _dobTextController,
) async {
  String fullName = _fullNameTextController.text;
  String cpr = _cprTextController.text;
  String phone = _phoneTextController.text;
  String email = _emailTextController.text;
  String password = _passwordTextController.text;
  String confirmPassword = _confirmPasswordTextController.text;
  List<String> errors = [];

  if (email.isEmpty) {
    errors.add('Email is required');
  } else if (!RegExp(emailPattern).hasMatch(email)) {
    errors.add('Invalid email format.');
  }

  if (password.isEmpty) {
    errors.add('Password is required');
  } else {
    final List<String> passwordErrors = [];

    if (password.length < 6) {
      passwordErrors.add('At least 6 characters');
    }

    if (!RegExp(upperCase).hasMatch(password)) {
      passwordErrors.add('At least one uppercase letter');
    }

    if (!RegExp(lowerCase).hasMatch(password)) {
      passwordErrors.add('At least one lowercase letter');
    }

    if (!RegExp(specialCharacters).hasMatch(password)) {
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

  if (fullName.isEmpty) {
    errors.add('Full Name is required.');
  }

  if (cpr.isEmpty) {
    errors.add('CPR is required.');
  } else if (!RegExp(cprPattern).hasMatch(cpr)) {
    errors.add('Invalid CPR format.');
  }

  if (phone.isEmpty) {
    errors.add('Phone number is required.');
  } else if (!RegExp(phonePattern).hasMatch(phone)) {
    errors.add('Invalid phone number format.');
  }

  if (_dobTextController.text.isEmpty) {
    errors.add('Date of Birth is required.');
  }

  if (errors.isNotEmpty) {
    showErrorDialog(context, errors.join('\n'));
    return;
  }

  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailTextController.text,
      password: _passwordTextController.text,
    );

    if (userCredential.user != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userCredential.user!.uid);

      await completeRegistration(
        context,
        userCredential.user!.uid,
        _fullNameTextController,
        _cprTextController,
        _phoneTextController,
        _selectedGender,
        _dobTextController,
      );
    }
  } catch (e) {
    showErrorDialog(context, 'Failed to sign up');
  }
}
