import 'package:flutter/material.dart';
import '../../../../const/app_colors.dart';
import '../../../../const/app_styles.dart';
import '../../../../utils/reuseable_widget.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController passwordTextController;
  final String title;
  final String hint;
  PasswordField(
      {super.key,
      required this.passwordTextController,
      required this.title,
      required this.hint});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            title,
            style: ralewayStyle.copyWith(
              fontSize: 12.0,
              color: Appcolors.blueDarkColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 6.0),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Appcolors.whiteColor,
          ),
          child: ReusableTextField(
            hintText: hint,
            icon: Icons.lock,
            isPassword: true,
            color: Appcolors.greyColor,
            controller: passwordTextController,
          ),
        ),
      ],
    );
  }
}
