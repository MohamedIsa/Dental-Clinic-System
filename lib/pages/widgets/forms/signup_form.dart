import 'package:flutter/material.dart';
import '../../../functions/auth/checkauthfield.dart';
import '../static/buttonform.dart';
import '../textfieldwidgets/cprfield.dart';
import '../textfieldwidgets/dobfield.dart';
import '../textfieldwidgets/emailfield.dart';
import '../textfieldwidgets/fullnamefield.dart';
import '../textfieldwidgets/genderfield.dart';
import '../textfieldwidgets/passwordfield.dart';
import '../textfieldwidgets/phonefield.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _fullnameTextController = TextEditingController();
  final TextEditingController _cprTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();
  final TextEditingController _dobTextController = TextEditingController();
  String _selectedGender = 'Male';
  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();
    _fullnameTextController.dispose();
    _cprTextController.dispose();
    _phoneTextController.dispose();
    _dobTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    void submitForm() {
      if (_formKey.currentState!.validate()) {
        check(
            context: context,
            emailTextController: _emailTextController,
            passwordTextController: _passwordTextController,
            confirmPasswordTextController: _confirmPasswordTextController,
            fullNameTextController: _fullnameTextController,
            cprTextController: _cprTextController,
            phoneTextController: _phoneTextController,
            selectedGender: _selectedGender,
            dobTextController: _dobTextController);
      }
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmailField(
            emailTextController: _emailTextController,
            onFieldSubmitted: (_) => submitForm(),
            isSignUp: true,
          ),
          const SizedBox(height: 20),
          NameField(
            fullNameTextController: _fullnameTextController,
            width: width,
            onFieldSubmitted: (_) => submitForm(),
          ),
          const SizedBox(height: 20),
          PhoneField(
            phoneTextController: _phoneTextController,
            width: width,
            onFieldSubmitted: (_) => submitForm(),
          ),
          const SizedBox(height: 20),
          GenderField(
            width: width,
            selectedGender: _selectedGender,
            onGenderChanged: (newGender) {
              setState(
                () => _selectedGender = newGender,
              );
            },
          ),
          const SizedBox(height: 20),
          DobField(
            dobTextController: _dobTextController,
            width: width,
            onFieldSubmitted: (_) => submitForm(),
          ),
          const SizedBox(height: 20),
          CprField(
            cprTextController: _cprTextController,
            width: width,
            onFieldSubmitted: (_) => submitForm(),
          ),
          const SizedBox(height: 20),
          PasswordField(
            passwordTextController: _passwordTextController,
            title: 'Password',
            hint: 'Enter your password',
            onFieldSubmitted: (_) => submitForm(),
            isSignUp: true,
          ),
          const SizedBox(height: 20),
          PasswordField(
            passwordTextController: _confirmPasswordTextController,
            confirmPasswordTextController: _passwordTextController,
            title: 'Confirm Password',
            hint: 'Re-enter your password',
            onFieldSubmitted: (_) => submitForm(),
            isSignUp: true,
            isConfirm: true,
          ),
          const SizedBox(height: 20),
          SizedBox(height: height * 0.03),
          ButtonForm(width: width, title: 'Sign Up', onTap: () => submitForm()),
        ],
      ),
    );
  }
}
