import 'package:flutter/material.dart';

import '../../../const/app_colors.dart';
import '../../../const/app_styles.dart';
import '../../../utils/reuseable_widget.dart';

class EmailField extends StatelessWidget {
  final TextEditingController emailTextController;
  EmailField({super.key, required this.emailTextController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'Email',
            style: ralewayStyle.copyWith(
              fontSize: 12.0,
              color: AppColors.blueDarkColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 6.0),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: AppColors.whiteColor,
          ),
          child: ReusableTextField(
            hintText: 'Enter email',
            icon: Icons.email,
            isPassword: false,
            color: AppColors.greyColor,
            controller: emailTextController,
          ),
        ),
      ],
    );
  }
}
