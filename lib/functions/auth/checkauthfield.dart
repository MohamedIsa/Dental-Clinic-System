import 'package:flutter/material.dart';
import 'package:senior/functions/auth/completefun.dart';
import 'package:senior/functions/auth/signupfun.dart';
import 'package:senior/utils/popups.dart';
import '../../pages/widgets/textfieldwidgets/cprfield.dart';
import '../../pages/widgets/textfieldwidgets/dobfield.dart';
import '../../pages/widgets/textfieldwidgets/emailfield.dart';
import '../../pages/widgets/textfieldwidgets/fullnamefield.dart';
import '../../pages/widgets/textfieldwidgets/passwordfield.dart';
import '../../pages/widgets/textfieldwidgets/phonefield.dart';
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
}) async {
  String email = emailTextController?.text ?? '';
  String password = passwordTextController?.text ?? '';
  String confirmPassword = confirmPasswordTextController?.text ?? '';
  String fullName = fullNameTextController.text;
  String cpr = cprTextController.text;
  String phone = phoneTextController.text;
  String dob = dobTextController.text;

  String emailError = await emailValidator(email);
  String passwordError = passwordValidator(password);
  String confirmPasswordError =
      confirmPasswordValidator(password, confirmPassword);
  String fullNameError = await fullNameValidator(fullName);
  String cprError = await cprValidator(cpr);
  String phoneError = phoneValidator(phone);
  String dobError = await dobValidator(dob);
  List<String> errors = [];
  if (uid != null && password == '' && selectedrole!.isNotEmpty ||
      uid == null) {
    if (emailError.isNotEmpty) errors.add(emailError);
  } else if (password.isNotEmpty && selectedrole!.isEmpty) {
    if (passwordError.isNotEmpty) errors.add(passwordError);
    if (confirmPasswordError.isNotEmpty) errors.add(confirmPasswordError);
  }
  if (fullNameError.isNotEmpty) errors.add(fullNameError);

  if (cprError.isNotEmpty) errors.add(cprError);

  if (phoneError.isNotEmpty) errors.add(phoneError);

  if (dobError.isNotEmpty) errors.add(dobError);

  if (errors.isNotEmpty) {
    showErrorDialog(context, errors.join('\n'));
    return;
  }

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
