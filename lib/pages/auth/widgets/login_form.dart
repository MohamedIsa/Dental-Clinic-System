import 'package:flutter/material.dart';
import '../../auth/widgets/reuseablewidgets/passwordfield.dart';
import '../../../const/app_colors.dart';
import 'functions/loginfun.dart';
import 'reuseablewidgets/emailfield.dart';

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
        _buildSignInButton(width),
      ],
    );
  }

  Widget _buildSignInButton(double width) {
    return Container(
      height: 50.0,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Appcolors.mainBlueColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () =>
              login(context, _emailTextController, _passwordTextController),
          borderRadius: BorderRadius.circular(16.0),
          child: Ink(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.1,
              vertical: 12.0,
            ),
            child: const Center(
              child: Text(
                'Sign In',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Appcolors.whiteColor,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
