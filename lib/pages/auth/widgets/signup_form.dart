import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../const/app_styles.dart';
import '../../../utils/popups.dart';
import '../../../const/app_colors.dart';
import '../../../utils/reuseable_widget.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();

  Future<void> _signUp() async {
    if (_passwordTextController.text != _confirmPasswordTextController.text) {
      showErrorDialog(context, 'Passwords do not match');
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      );

      if (userCredential.user != null) {
        // Persist the user's ID locally
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userCredential.user!.uid);

        // Navigate to the dashboard
        Navigator.pushNamed(context, '/dashboard');
      }
    } catch (e) {
      showErrorDialog(context, 'Failed to sign up');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEmailField(),
        const SizedBox(height: 20),
        _buildPasswordField(),
        const SizedBox(height: 20),
        _buildConfirmPasswordField(),
        SizedBox(height: height * 0.03),
        _buildSignUpButton(width),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'Email',
            style: ralewayStyle.copyWith(
              fontSize: 12.0,
              color: Appcolors.blueDarkColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 6.0),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Appcolors.whiteColor,
          ),
          child: ReusableTextField('Enter email', Icons.email, false,
              Appcolors.greyColor, _emailTextController),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'Password',
            style: ralewayStyle.copyWith(
              fontSize: 12.0,
              color: Appcolors.blueDarkColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 6.0),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Appcolors.whiteColor,
          ),
          child: ReusableTextField('Enter password', Icons.lock, true,
              Appcolors.greyColor, _passwordTextController),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'Confirm Password',
            style: ralewayStyle.copyWith(
              fontSize: 12.0,
              color: Appcolors.blueDarkColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 6.0),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Appcolors.whiteColor,
          ),
          child: ReusableTextField('Confirm password', Icons.lock, true,
              Appcolors.greyColor, _confirmPasswordTextController),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(double width) {
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
          onTap: _signUp,
          borderRadius: BorderRadius.circular(16.0),
          child: Ink(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.1,
              vertical: 12.0,
            ),
            child: const Center(
              child: Text(
                'Sign Up',
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
