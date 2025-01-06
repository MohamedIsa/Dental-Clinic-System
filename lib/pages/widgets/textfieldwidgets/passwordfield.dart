import 'package:flutter/material.dart';
import '../../../const/app_colors.dart';
import '../../../const/app_styles.dart';
import '../../../functions/auth/patterns.dart';
import '../../../utils/reuseable_widget.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController passwordTextController;
  final String title;
  final String hint;
  final Function(String)? onFieldSubmitted;
  PasswordField(
      {super.key,
      required this.passwordTextController,
      required this.title,
      required this.hint,
      this.onFieldSubmitted});
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
            hintText: hint,
            icon: Icons.lock,
            isPassword: true,
            color: AppColors.greyColor,
            controller: passwordTextController,
            onFieldSubmitted: onFieldSubmitted,
          ),
        ),
      ],
    );
  }
}

String passwordValidator(String password) {
  if (password.isEmpty) {
    return 'Password is required';
  } else {
    final List<String> passwordErrors = [];

    if (password.length < 6) {
      passwordErrors.add('At least 6 characters');
    }

    if (!RegExp(Patterns.upperCase).hasMatch(password)) {
      passwordErrors.add('At least one uppercase letter');
    }

    if (!RegExp(Patterns.lowerCase).hasMatch(password)) {
      passwordErrors.add('At least one lowercase letter');
    }

    if (!RegExp(Patterns.specialCharacters).hasMatch(password)) {
      passwordErrors.add('At least one special character');
    }

    if (passwordErrors.isNotEmpty) {
      return passwordErrors.join(', ');
    }
  }
  return '';
}

String confirmPasswordValidator(String password, String confirmPassword) {
  if (confirmPassword.isEmpty) {
    return 'Confirm password is required';
  } else if (confirmPassword != password) {
    return 'Passwords do not match';
  }
  return '';
}
