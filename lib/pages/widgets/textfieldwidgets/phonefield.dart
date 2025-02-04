import 'package:flutter/material.dart';
import '../../../const/app_colors.dart';
import '../../../functions/auth/patterns.dart';
import '../../../utils/reuseabletextfield.dart';

class Phonefield extends StatelessWidget {
  final TextEditingController phoneTextController;
  final double width;
  final Function(String)? onFieldSubmitted;
  const Phonefield(
      {super.key,
      required this.phoneTextController,
      required this.width,
      this.onFieldSubmitted});

  @override
  Widget build(BuildContext context) {
    return ReusableTextField(
      title: 'Phone Number',
      hintText: 'Enter Your phone number',
      icon: Icons.phone,
      isPassword: false,
      color: AppColors.greyColor,
      controller: phoneTextController,
      isNumeric: true,
      onFieldSubmitted: onFieldSubmitted,
      validator: (value) => phoneValidator(value!),
    );
  }
}

String? phoneValidator(String phone) {
  if (phone.isEmpty) {
    return 'Phone number is required.';
  } else if (phone.isNotEmpty &&
      !RegExp(Patterns.phonePattern).hasMatch(phone)) {
    return 'Invalid phone number format.';
  }
  return null;
}
