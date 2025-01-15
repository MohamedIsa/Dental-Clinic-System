import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senior/functions/auth/patterns.dart';
import 'package:senior/functions/updateaccount/updateaccount.dart';
import '../../utils/popups.dart';

void checkFields(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController cprController,
    TextEditingController dobController,
    TextEditingController selectedGender,
    TextEditingController phoneController) async {
  List<String> errors = [];
  if (nameController.text.isEmpty ||
      cprController.text.isEmpty ||
      dobController.text.isEmpty ||
      selectedGender.text.isEmpty ||
      phoneController.text.isEmpty) {
    errors.add('Please fill all fields.');
    return;
  }
  if (cprController.text.length != 9) {
    errors.add('CPR must be 9 digits.');
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  var queryResult =
      await users.where('cpr', isEqualTo: cprController.text).get();

  if (queryResult.docs.first['cpr'] != cprController.text) {
    errors.add('CPR already exists.');
  }

  if (!RegExp(Patterns.phonePattern).hasMatch(phoneController.text)) {
    errors.add('Invalid Phone format.');
  }

  if (!RegExp(Patterns.cprPattern).hasMatch(cprController.text)) {
    errors.add('Invalid CPR format.');
  }
  errors.isNotEmpty
      ? showErrorDialog(context, errors.join('\n'))
      : updateUser(context, nameController, cprController, dobController,
          selectedGender, phoneController);
}
