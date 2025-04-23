import 'package:flutter/material.dart';
import '../../../const/app_colors.dart';
import '../../../functions/auth/patterns.dart';
import '../../../utils/reuseabletextfield.dart';

class EmailField extends StatefulWidget {
  final TextEditingController emailTextController;
  final Function(String)? onFieldSubmitted;
  final bool isSignUp;

  const EmailField({
    super.key,
    required this.emailTextController,
    this.onFieldSubmitted,
    this.isSignUp = false,
  });

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  String? asyncError;

  @override
  Widget build(BuildContext context) {
    return ReusableTextField(
      title: 'Email',
      hintText: 'Enter email',
      icon: Icons.email,
      isPassword: false,
      color: AppColors.greyColor,
      controller: widget.emailTextController,
      validator: (value) {
        final syncError = emailValidatorSync(value!);
        return syncError ?? asyncError;
      },
      onFieldSubmitted: (value) {
        widget.onFieldSubmitted?.call(value);
      },
    );
  }
}

String? emailValidatorSync(String email) {
  if (email.isEmpty) {
    return 'Email is required';
  } else if (!RegExp(Patterns.emailPattern).hasMatch(email)) {
    return 'Invalid email format.';
  }
  return null;
}
