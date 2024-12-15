import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senior/const/app_colors.dart';
import 'package:senior/const/app_styles.dart';
import 'package:senior/utils/reuseable_widget.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _errorMessage = '';

  Future<void> _resetPassword() async {
    try {
      final snapshot = await _firestore
          .collection('user')
          .where('Email', isEqualTo: _emailController.text)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await _auth.sendPasswordResetEmail(email: _emailController.text);
        setState(() {
          _errorMessage =
              'Password reset email sent. Please check your inbox.\nIt may take a few minutes to arrive.';
        });
      } else {
        setState(() {
          _errorMessage = 'This email is not registered.';
        });
      }
    } catch (error) {
      print(error);
      setState(() {
        _errorMessage = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

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
          child: ReusableTextField(
            'Enter email',
            Icons.email,
            false,
            Appcolors.greyColor,
            _emailController,
          ),
        ),
        SizedBox(height: height * 0.04),
        Container(
          height: 50.0,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Appcolors.mainBlueColor,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _resetPassword,
              borderRadius: BorderRadius.circular(16.0),
              child: Ink(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.1,
                  vertical: 12.0,
                ),
                child: Center(
                  child: Text(
                    'Reset Password',
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
        ),
        SizedBox(height: height * 0.04),
        Text(
          _errorMessage,
          style: ralewayStyle.copyWith(
            color: Colors.red,
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        InkWell(
          onTap: () {},
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Log in',
              style: ralewayStyle.copyWith(
                fontSize: 12.0,
                color: Appcolors.mainBlueColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
