import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:senior/pages/widgets/forms/forgot_form.dart';
import 'package:senior/pages/widgets/headers/header.dart';
import 'package:senior/pages/widgets/static/googlelog.dart';
import 'package:senior/pages/widgets/navigations/signinprompt.dart';
import 'package:senior/pages/widgets/static/socialsignup.dart';
import '../../const/app_colors.dart';
import '../../const/app_styles.dart';
import '../../functions/auth/checkuserloggedin.dart';
import '../../utils/responsive_widget.dart';
import '../widgets/forms/complete_form.dart';
import '../widgets/forms/login_form.dart';
import '../widgets/forms/signup_form.dart';
import '../widgets/navigations/forgotpasswordlink.dart';
import '../widgets/navigations/signupprompt.dart';
import '../../functions/auth/navigationfun.dart';

class AuthScreen extends StatefulWidget {
  final bool isSignUp;
  final bool isCompleteDetails;
  final bool isForgotPassword;
  final String? uid;
  const AuthScreen({
    super.key,
    this.uid,
    required this.isSignUp,
    required this.isCompleteDetails,
    required this.isForgotPassword,
  });

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
    String? userid = FirebaseAuth.instance.currentUser?.uid;
    if (!_isSignUp! &&
        !_isCompleteDetails &&
        !_isForgotPassword &&
        userid != null) {
      checkUserLoggedIn(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.backColor,
      body: SafeArea(
        child: SizedBox(
          height: height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ResponsiveWidget.isSmallScreen(context)
                  ? const SizedBox()
                  : Expanded(
                      child: Container(
                        height: height,
                        padding: const EdgeInsets.all(48),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.blueDarkColor,
                              AppColors.primaryColor,
                              AppColors.accentColor,
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              width: 180,
                              height: 180,
                              fit: BoxFit.contain,
                            ),
                            const Spacer(),
                            Text(
                              'Modern dental operations in one workspace',
                              style: ralewayStyle.copyWith(
                                color: AppColors.whiteColor,
                                fontSize: 36,
                                height: 1.15,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.0,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'Appointments, patient records, staff access, and treatment history with Firebase-backed sync.',
                              style: ralewayStyle.copyWith(
                                color: AppColors.whiteColor.withValues(
                                  alpha: 0.86,
                                ),
                                fontSize: 16,
                                height: 1.55,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Container(
                      height: height,
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveWidget.isSmallScreen(context)
                            ? 24
                            : 40,
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(
                          top: ResponsiveWidget.isSmallScreen(context)
                              ? 48
                              : 88,
                          bottom: 40.0,
                        ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.borderColor),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.blueDarkColor.withValues(
                                  alpha: 0.08,
                                ),
                                blurRadius: 24,
                                offset: const Offset(0, 14),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(
                              ResponsiveWidget.isSmallScreen(context) ? 24 : 36,
                            ),
                            child: _buildFormContent(height),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(double height) {
    if (_isForgotPassword) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(
            headerName: 'Reset Password',
            message: 'Enter your email address and we will send reset steps.',
          ),
          SizedBox(height: height * 0.046),
          const ForgotPasswordForm(),
          TextButton(
            onPressed: () => toggleSignIn(context),
            child: Text(
              'Log in',
              style: ralewayStyle.copyWith(
                fontSize: 13.0,
                color: AppColors.mainBlueColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      );
    }

    if (_isCompleteDetails) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(
            headerName: 'Complete Details',
            message: 'Add the missing profile details to finish registration.',
          ),
          SizedBox(height: height * 0.046),
          CompleteForm(uid: widget.uid ?? ''),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _isSignUp!
            ? const Header(
                headerName: 'Sign Up',
                message: 'Create an account to manage clinic workflows.',
              )
            : const Header(
                headerName: 'Sign In',
                message: 'Enter your credentials to access your workspace.',
              ),
        SizedBox(height: height * 0.046),
        _isSignUp! ? const SignUpForm() : const LoginForm(),
        SizedBox(height: height * 0.02),
        _isSignUp! ? SigninPrompt() : SignUpPrompt(),
        SizedBox(height: height * 0.02),
        _isSignUp! ? const SizedBox() : ForgotPasswordLink(),
        SocialSignUpSection(),
        Googlelog(),
      ],
    );
  }
}
