import 'package:flutter/material.dart';
import '../../utils/popups.dart';
import '../auth/exists.dart';
import 'updateaccount.dart';

void checkFields(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController cprController,
    TextEditingController dobController,
    String selectedGender,
    TextEditingController phoneController) {
  if (cprExists(cprController.text) as bool == true) {
    showErrorDialog(context, 'CPR already exists');
    return;
  }
  updateUser(context, nameController, cprController, dobController,
      selectedGender, phoneController);
}
