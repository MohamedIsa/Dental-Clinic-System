import 'package:flutter/material.dart';
import 'package:senior/functions/auth/checkauthfield.dart';
import 'package:senior/pages/widgets/static/buttonform.dart';
import 'package:senior/pages/widgets/textfieldwidgets/cprfield.dart';
import 'package:senior/pages/widgets/textfieldwidgets/dobfield.dart';
import 'package:senior/pages/widgets/textfieldwidgets/emailfield.dart';
import 'package:senior/pages/widgets/textfieldwidgets/fullnamefield.dart';
import 'package:senior/pages/widgets/textfieldwidgets/genderfield.dart';
import 'package:senior/pages/widgets/textfieldwidgets/passwordfield.dart';
import 'package:senior/pages/widgets/textfieldwidgets/phonefield.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _FullnameTextController = TextEditingController();
  final TextEditingController _cprTextController = TextEditingController();
  final TextEditingController _PhoneTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();
  final TextEditingController _dobTextController = TextEditingController();
  String _selectedGender = 'Male';
  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();
    _FullnameTextController.dispose();
    _cprTextController.dispose();
    _PhoneTextController.dispose();
    _dobTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EmailField(emailTextController: _emailTextController),
        const SizedBox(height: 20),
        NameField(
            fullNameTextController: _FullnameTextController, width: width),
        const SizedBox(height: 20),
        Phonefield(phoneTextController: _PhoneTextController, width: width),
        const SizedBox(height: 20),
        GenderField(width: width, selectedGender: _selectedGender),
        const SizedBox(height: 20),
        DobField(dobTextController: _dobTextController, width: width),
        const SizedBox(height: 20),
        CprField(cprTextController: _cprTextController, width: width),
        const SizedBox(height: 20),
        PasswordField(
            passwordTextController: _passwordTextController,
            title: 'Password',
            hint: 'Enter your password'),
        const SizedBox(height: 20),
        PasswordField(
            passwordTextController: _confirmPasswordTextController,
            title: 'Confirm Password',
            hint: 'Re-enter your password'),
        const SizedBox(height: 20),
        SizedBox(height: height * 0.03),
        ButtonForm(
            width: width,
            title: 'Sign Up',
            onTap: () {
              check(
                  context,
                  null,
                  _emailTextController,
                  _passwordTextController,
                  _confirmPasswordTextController,
                  _FullnameTextController,
                  _cprTextController,
                  _PhoneTextController,
                  _selectedGender,
                  _dobTextController,
                  null);
            }),
      ],
    );
  }
}
