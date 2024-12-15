import 'package:flutter/material.dart';
import 'package:senior/const/app_colors.dart';
import 'package:senior/const/app_styles.dart';

class ForgotHeader extends StatelessWidget {
  const ForgotHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Forgot',
                style: ralewayStyle.copyWith(
                  fontSize: 25.0,
                  color: Appcolors.blueDarkColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
              TextSpan(
                text: ' Reset Password 👇',
                style: ralewayStyle.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Appcolors.blueDarkColor,
                  fontSize: 25.0,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Hey, Enter your email to change your password',
          style: ralewayStyle.copyWith(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: Appcolors.textColor,
          ),
        ),
      ],
    );
  }
}
