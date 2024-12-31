import 'package:flutter/material.dart';
import '../../const/app_colors.dart';
import '../../const/app_styles.dart';
import '../../functions/auth/navigationfun.dart';

class SignUpPrompt extends StatelessWidget {
  const SignUpPrompt({super.key});

  @override
  Widget build(BuildContext context) {
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
            onPressed: () => toggleForm(context),
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
}
