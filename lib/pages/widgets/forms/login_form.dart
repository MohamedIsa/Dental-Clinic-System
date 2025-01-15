import 'package:flutter/material.dart';
import 'package:senior/pages/widgets/static/buttonform.dart';
import '../textfieldwidgets/passwordfield.dart';
import '../../../functions/auth/loginfun.dart';
import '../textfieldwidgets/emailfield.dart';

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
        EmailField(
          emailTextController: _emailTextController,
          onFieldSubmitted: (_) =>
              login(context, _emailTextController, _passwordTextController),
        ),
        const SizedBox(height: 20),
        PasswordField(
            passwordTextController: _passwordTextController,
            title: 'Password',
            hint: 'Enter password',
            onFieldSubmitted: (_) =>
                login(context, _emailTextController, _passwordTextController)),
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
