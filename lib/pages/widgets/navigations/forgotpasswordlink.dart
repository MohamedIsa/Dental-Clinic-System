import 'package:flutter/material.dart';
import '../../../const/app_colors.dart';
import '../../../const/app_styles.dart';
import '../../../functions/auth/navigationfun.dart';

class ForgotPasswordLink extends StatelessWidget {
  const ForgotPasswordLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () => toggleForgotPassword(context),
        child: Text(
          'Forgot Password?',
          style: ralewayStyle.copyWith(
            fontSize: 12.0,
            color: AppColors.mainBlueColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
