import 'package:flutter/material.dart';
import 'package:senior/pages/widgets/forms/forgot_form.dart';
import 'package:senior/pages/widgets/headers/header.dart';
import 'package:senior/pages/widgets/static/googlelog.dart';
import 'package:senior/pages/widgets/navigations/signinprompt.dart';
import 'package:senior/pages/widgets/static/socialsignup.dart';
import '../../../const/app_colors.dart';
import '../../../const/app_styles.dart';
import '../../../utils/responsive_widget.dart';
import '../../widgets/forms/complete_form.dart';
import '../../widgets/forms/login_form.dart';
import '../../widgets/forms/signup_form.dart';
import '../../widgets/navigations/forgotpasswordlink.dart';
import '../../widgets/navigations/signupprompt.dart';
import '../../../functions/auth/navigationfun.dart';

class AuthScreen extends StatefulWidget {
  final bool isSignUp;
  final bool isCompleteDetails;
  final bool isForgotPassword;
  final String? uid;
  const AuthScreen(
      {super.key,
      this.uid,
      required this.isSignUp,
      required this.isCompleteDetails,
      required this.isForgotPassword});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool? _isSignUp;
  bool _isForgotPassword = false;
  bool _isCompleteDetails = false;

  @override
  void initState() {
    super.initState();
    _isSignUp = widget.isSignUp;
    _isCompleteDetails = widget.isCompleteDetails;
    _isForgotPassword = widget.isForgotPassword;
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
                color: AppColors.backColor,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: _isForgotPassword
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: height * 0.2),
                            const Header(
                                headerName: 'Reset Password',
                                message:
                                    'Hey, Enter your email to change your password'),
                            SizedBox(height: height * 0.064),
                            const ForgotPasswordForm(),
                            InkWell(
                              onTap: () {},
                              child: TextButton(
                                onPressed: () => toggleSignIn(context),
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
                        )
                      : _isCompleteDetails
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: height * 0.2),
                                const Header(
                                    headerName: 'Complete details',
                                    message:
                                        'Hey, Complete Your details to register in to the system.'),
                                SizedBox(height: height * 0.064),
                                CompleteForm(
                                  uid: widget.uid ?? '',
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: height * 0.2),
                                _isSignUp!
                                    ? const Header(
                                        headerName: 'Sign Up',
                                        message:
                                            'Hey, Enter your details to create a new account.')
                                    : const Header(
                                        headerName: 'Sign In',
                                        message:
                                            'Hey, Enter your details to get sign in \nto your account.'),
                                SizedBox(height: height * 0.064),
                                _isSignUp!
                                    ? const SignUpForm()
                                    : const LoginForm(),
                                SizedBox(height: height * 0.02),
                                _isSignUp! ? SigninPrompt() : SignUpPrompt(),
                                SizedBox(height: height * 0.02),
                                _isSignUp!
                                    ? const SizedBox()
                                    : ForgotPasswordLink(),
                                SocialSignUpSection(),
                                Googlelog(),
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
}
