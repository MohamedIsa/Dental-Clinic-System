import 'package:flutter/material.dart';
import 'package:senior/const/app_colors.dart';
import 'package:senior/const/app_styles.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Let\'s',
                style: ralewayStyle.copyWith(
                  fontSize: 25.0,
                  color: Appcolors.blueDarkColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
              TextSpan(
                text: ' Sign Up 👇',
                style: ralewayStyle.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Appcolors.blueDarkColor,
                  fontSize: 25.0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Hey, Enter your details to create a new account.',
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
