import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senior/const/app_styles.dart';
import 'package:senior/pages/widgets/static/buttonform.dart';
import 'package:senior/pages/widgets/textfieldwidgets/emailfield.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: _emailController.text)
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
        EmailField(
            emailTextController: _emailController,
            onFieldSubmitted: (_) => _resetPassword),
        SizedBox(height: height * 0.04),
        ButtonForm(width: width, title: 'ResetPassword', onTap: _resetPassword),
        SizedBox(height: height * 0.04),
        Text(
          _errorMessage,
          style: ralewayStyle.copyWith(
            color: Colors.red,
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
