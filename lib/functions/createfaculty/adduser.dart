import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/users.dart';
import '../../utils/password_generator.dart';
import '../../utils/popups.dart';

Future<void> adduser(
  BuildContext context,
  TextEditingController fullNameController,
  TextEditingController emailController,
  TextEditingController cprController,
  TextEditingController phoneNumberController,
  String selectedGender,
  TextEditingController birthdayController,
  String selectedRole,
) async {
  try {
    await dotenv.load(fileName: ".env");
    String randomPassword = generateRandomPassword();

    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: randomPassword,
    );
// inside the assets folder the .env can be found
    await FirebaseAuth.instance.currentUser
        ?.updateProfile(displayName: fullNameController.text);

    Users newUser = Users(
      id: userCredential.user!.uid,
      name: fullNameController.text,
      email: emailController.text,
      role: selectedRole.toLowerCase(),
      phone: phoneNumberController.text,
      cpr: cprController.text,
      dob: birthdayController.text,
      gender: selectedGender,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(newUser.id)
        .set(newUser.toFirestore());

    final response = await http.post(
      Uri.parse(
        dotenv.env['API_URL']!,
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'recipientEmail': emailController.text,
        'subject': 'Your Account Details',
        'message':
            'Hello ${fullNameController.text},\n\nYour account has been created successfully. Here are your login details:\n\nEmail: ${emailController.text}\nPassword: $randomPassword\n\nPlease change your password after logging in for the first time.\n\nBest regards,\nDental Clinic System',
      }),
    );

    if (response.statusCode == 200) {
      print('Email sent successfully');
      showMessagealert(context, 'User added and email sent successfully');
    } else {
      print('Failed to send email: ${response.body}');
      showErrorDialog(
          context, 'User added, but failed to send the email. Please retry.');
    }

    Navigator.of(context).pop();
  } catch (e) {
    print('Error: $e');
    showErrorDialog(context, 'An error occurred while saving the user.');
  }
}
