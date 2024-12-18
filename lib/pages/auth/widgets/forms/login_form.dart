import 'package:flutter/material.dart';
import 'package:senior/pages/auth/widgets/buttonform.dart';
import '../reuseablewidgets/passwordfield.dart';
import '../functions/loginfun.dart';
import '../reuseablewidgets/emailfield.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();

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
        PasswordField(
            passwordTextController: _passwordTextController,
            title: 'Password',
            hint: 'Enter password'),
        SizedBox(height: height * 0.03),
        ButtonForm(
            width: width,
            title: 'Sign In',
            onTap: () {
              login(context, _emailTextController, _passwordTextController);
            }),
      ],
    );
  }
}
