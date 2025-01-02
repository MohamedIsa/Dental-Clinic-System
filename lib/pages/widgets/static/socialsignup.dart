import 'package:flutter/material.dart';
import '../../../const/app_colors.dart';
import '../../../const/app_styles.dart';

class SocialSignUpSection extends StatelessWidget {
  const SocialSignUpSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text('Or Sign Up With',
              style: ralewayStyle.copyWith(
                fontSize: 12.0,
                color: AppColors.greyColor,
                fontWeight: FontWeight.w600,
              )),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
