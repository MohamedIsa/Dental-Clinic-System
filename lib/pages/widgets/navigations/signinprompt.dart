import 'package:flutter/material.dart';
import '../../../functions/auth/navigationfun.dart';

import '../../../const/app_colors.dart';
import '../../../const/app_styles.dart';

class SigninPrompt extends StatelessWidget {
  const SigninPrompt({super.key});

  @override
  Widget build(BuildContext context) {
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
            onPressed: () => toggleSignIn(context),
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
