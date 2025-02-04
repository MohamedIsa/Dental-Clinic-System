import 'package:flutter/material.dart';
import '../../../const/app_colors.dart';
import '../../../utils/reuseabletextfield.dart';

class NameField extends StatelessWidget {
  final TextEditingController fullNameTextController;
  final double width;
  final Function(String)? onFieldSubmitted;
  const NameField(
      {super.key,
      required this.fullNameTextController,
      required this.width,
      this.onFieldSubmitted});

  @override
  Widget build(BuildContext context) {
    return ReusableTextField(
      title: 'Full Name',
      hintText: 'Enter Full Name',
      icon: Icons.person,
      isPassword: false,
      color: AppColors.greyColor,
      controller: fullNameTextController,
      onFieldSubmitted: onFieldSubmitted,
      validator: (value) => fullNameValidator(value!),
    );
  }
}

String? fullNameValidator(String fullName) {
  if (fullName.isEmpty) {
    return 'Full Name is required';
  } else if (fullName.length < 3) {
    return 'Full Name must be at least 3 characters';
  }
  return null;
}
