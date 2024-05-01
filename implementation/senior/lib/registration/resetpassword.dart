import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senior/app_colors.dart';
import 'package:senior/app_icons.dart';
import 'package:senior/app_styles.dart';
import 'package:senior/responsive_widget.dart';
import 'package:senior/registration/reuseable_widget.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
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
      // Email exists in Firestore, send reset password email
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
    setState(() {
      _errorMessage = error.toString();
    });
  }
}

  @override
  Widget build(BuildContext context) {
        double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backColor,
      body: SizedBox(
        height: height,
        width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ResponsiveWidget.isSmallScreen(context)
                ? const SizedBox()
                : Expanded(
                    child: Container(
                      height: height,
                      color: AppColors.mainBlueColor,
                      child: Center(
                        child: Text(
                          'Dental Clinic',
                          style: ralewayStyle.copyWith(
                            fontSize: 48.0,
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
            Expanded(
              child: Container(
                height: height,
                margin: EdgeInsets.symmetric(
                  horizontal: ResponsiveWidget.isSmallScreen(context)
                      ? height * 0.032
                      : height * 0.12,
                ),
                color: AppColors.backColor,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.2),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Let’s',
                              style: ralewayStyle.copyWith(
                                fontSize: 25.0,
                                color: AppColors.blueDarkColor,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            TextSpan(
                              text: ' Reset Password 👇',
                              style: ralewayStyle.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.blueDarkColor,
                                fontSize: 25.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Text(
                        'Hey, Enter your email to change your password .',
                        style: ralewayStyle.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: height * 0.064),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Email',
                          style: ralewayStyle.copyWith(
                            fontSize: 12.0,
                            color: AppColors.blueDarkColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: AppColors.whiteColor,
                        ),
                        child: ReusableTextField('Enter email',
                            AppIcons.emailIcon, false, _emailController),
                      ),
                      SizedBox(height: height * 0.04),
                     Container(
                        height: 50.0,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: AppColors.mainBlueColor,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell( 
                            onTap: () {
                              _resetPassword();
                               },
                            borderRadius: BorderRadius.circular(16.0),
                            child: Ink(
                              padding: EdgeInsets.symmetric(
                                horizontal: width *
                                    0.1, // Adjust the horizontal padding as needed
                                vertical:
                                    12.0, // Adjust the vertical padding as needed
                              ),
                              child: Center(
                                child: Text(
                                  'Reset Password',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.whiteColor,
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
                                onPressed: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                child: Text(
                                  'Log in',
                                  style: ralewayStyle.copyWith(
                                    fontSize: 12.0,
                                    color: AppColors.mainBlueColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

    
    /*Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            reusableTextField('Email', AppIcons.emailIcon, false, _emailController),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _resetPassword,
              child: Text('Reset Password'),
            ),
            SizedBox(height: 16.0),
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
*/