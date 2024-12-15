import 'package:flutter/material.dart';
import 'package:senior/pages/auth/widgets/forgot_form.dart';
import '../../const/app_colors.dart';
import '../../const/app_styles.dart';
import '../../utils/googlesignin.dart';
import '../../utils/responsive_widget.dart';
import 'widgets/forgot_header.dart';
import 'widgets/login_header.dart';
import 'widgets/login_form.dart';
import 'widgets/signup_header.dart';
import 'widgets/signup_form.dart';

class Authscreen extends StatefulWidget {
  const Authscreen({Key? key}) : super(key: key);

  @override
  State<Authscreen> createState() => _AuthscreenState();
}

class _AuthscreenState extends State<Authscreen> {
  bool _isSignUp = false;
  bool _isForgotPassword = false;

  void _toggleForm() {
    setState(() {
      _isSignUp = !_isSignUp;
    });
  }

  void _toggleForgotPassword() {
    setState(() {
      _isForgotPassword = !_isForgotPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Appcolors.backColor,
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
                      color: Colors.lightBlue,
                      child: Center(
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: width * 0.4,
                          height: height * 0.4,
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
                color: Appcolors.backColor,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: _isForgotPassword
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: height * 0.2),
                            const ForgotHeader(),
                            SizedBox(height: height * 0.064),
                            const ForgotPasswordForm(),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: height * 0.2),
                            _isSignUp
                                ? const SignUpHeader()
                                : const LoginHeader(),
                            SizedBox(height: height * 0.064),
                            _isSignUp ? const SignUpForm() : const LoginForm(),
                            SizedBox(height: height * 0.02),
                            _isSignUp
                                ? _buildSignInPrompt()
                                : _buildSignUpPrompt(),
                            SizedBox(height: height * 0.02),
                            _isSignUp
                                ? const SizedBox()
                                : _buildForgotPasswordLink(),
                            _isSignUp
                                ? _buildSocialSignUpSection(width)
                                : _buildSocialSignInSection(width),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 50.0,
                                width: 50.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: Appcolors.mainBlueColor,
                                ),
                                child: IconButton(
                                  onPressed: () => signInWithGoogle(context),
                                  icon: Icon(Icons.g_mobiledata,
                                      color: Appcolors.whiteColor),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.02),
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

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: _toggleForgotPassword,
        child: Text(
          'Forgot Password?',
          style: ralewayStyle.copyWith(
            fontSize: 12.0,
            color: Appcolors.mainBlueColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpPrompt() {
    return Padding(
      padding: const EdgeInsets.only(left: 11.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Don\'t have an account? ',
            style: ralewayStyle.copyWith(
              fontSize: 12.0,
              color: Appcolors.greyColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextButton(
            onPressed: _toggleForm,
            child: Text(
              'Sign Up',
              style: ralewayStyle.copyWith(
                fontSize: 12.0,
                color: Appcolors.mainBlueColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialSignInSection(double width) {
    return Column(
      children: [
        Center(
          child: Text('Or Sign In With',
              style: ralewayStyle.copyWith(
                fontSize: 12.0,
                color: Appcolors.greyColor,
                fontWeight: FontWeight.w600,
              )),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSocialSignUpSection(double width) {
    return Column(
      children: [
        Center(
          child: Text('Or Sign Up With',
              style: ralewayStyle.copyWith(
                fontSize: 12.0,
                color: Appcolors.greyColor,
                fontWeight: FontWeight.w600,
              )),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSignInPrompt() {
    return Padding(
      padding: const EdgeInsets.only(left: 11.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Already have an account? ',
            style: ralewayStyle.copyWith(
              fontSize: 12.0,
              color: Appcolors.greyColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextButton(
            onPressed: _toggleForm,
            child: Text(
              'Sign In',
              style: ralewayStyle.copyWith(
                fontSize: 12.0,
                color: Appcolors.mainBlueColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
