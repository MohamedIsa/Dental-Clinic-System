import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../const/app_styles.dart';
import '../../../utils/popups.dart';
import '../../../const/app_colors.dart';
import '../../../utils/reuseable_widget.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  Future<void> _login() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      );

      if (userCredential.user != null) {
        // Persist the user's ID locally
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userCredential.user!.uid);

        // Check user role and navigate accordingly
        await _navigateBasedOnUserRole(userCredential.user!.uid);
      }
    } catch (e) {
      _handleLoginError();
    }
  }

  Future<void> _navigateBasedOnUserRole(String userId) async {
    final roles = ['patient', 'admin', 'receptionist', 'dentist'];

    for (String role in roles) {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection(role).doc(userId).get();

      if (snapshot.exists) {
        switch (role) {
          case 'patient':
            Navigator.pushNamed(context, '/dashboard');
            return;
          case 'admin':
            Navigator.pushNamed(context, '/admin');
            return;
          case 'receptionist':
            Navigator.pushNamed(context, '/receptionist');
            return;
          case 'dentist':
            Navigator.pushNamed(context, '/dentist');
            return;
        }
      }
    }

    showErrorDialog(context, 'User not found');
  }

  void _handleLoginError() {
    if (_emailTextController.text.isEmpty ||
        _passwordTextController.text.isEmpty) {
      showErrorDialog(context, 'Please fill all the fields');
    } else {
      showErrorDialog(context, 'Invalid email or password');
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
        SizedBox(height: height * 0.03),
        _buildSignInButton(width),
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
          onTap: _login,
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
