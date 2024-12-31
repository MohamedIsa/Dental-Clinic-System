import 'package:flutter/material.dart';

import '../../../const/app_colors.dart';
import '../../../const/app_styles.dart';

class SocialSignInSection extends StatelessWidget {
  const SocialSignInSection({super.key});

  @override
  Widget build(BuildContext context) {
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
        const SizedBox(height: 20),
      ],
    );
  }
}
