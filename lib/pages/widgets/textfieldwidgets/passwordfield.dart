import 'package:flutter/material.dart';
import '../../../const/app_colors.dart';
import '../../../functions/auth/patterns.dart';
import '../../../utils/reuseabletextfield.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController passwordTextController;
  final TextEditingController? confirmPasswordTextController;
  final String title;
  final String hint;
  final Function(String)? onFieldSubmitted;
  final bool isSignUp;
  final bool isConfirm;

  const PasswordField({
    super.key,
    required this.passwordTextController,
    this.confirmPasswordTextController,
    required this.title,
    required this.hint,
    this.onFieldSubmitted,
    this.isSignUp = true,
    this.isConfirm = false,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  String? asyncError;

  void handleValidation(String value) {
    final passwordError =
        widget.isConfirm ? null : passwordValidator(value, widget.isSignUp);
    final confirmError = widget.isConfirm
        ? confirmPasswordValidator(widget.confirmPasswordTextController!.text,
            widget.passwordTextController.text)
        : null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          asyncError = passwordError?.isNotEmpty == true
              ? passwordError
              : confirmError?.isNotEmpty == true
                  ? confirmError
                  : null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReusableTextField(
      title: widget.title,
      hintText: widget.hint,
      icon: Icons.lock,
      isPassword: true,
      color: AppColors.greyColor,
      controller: widget.passwordTextController,
      validator: (value) {
        handleValidation(value!);
        return asyncError;
      },
      onChanged: (value) => handleValidation(value),
      onFieldSubmitted: (value) {
        handleValidation(value);
        widget.onFieldSubmitted?.call(value);
      },
    );
  }
}

String passwordValidator(String? password, bool isSignUp) {
  if (password == null || password.isEmpty) {
    return 'Password is required';
  }

  if (isSignUp) {
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
      return passwordErrors.join('\n');
    }
  }

  return '';
}

String confirmPasswordValidator(String? password, String? confirmPassword) {
  if (confirmPassword == null || confirmPassword.isEmpty) {
    return 'Confirm password is required';
  } else if (confirmPassword != password) {
    return 'Passwords do not match';
  }
  return '';
}
