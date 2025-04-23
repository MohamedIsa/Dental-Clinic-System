import 'package:flutter/material.dart';
import '../../../const/app_colors.dart';
import '../../../functions/auth/patterns.dart';
import '../../../utils/reuseabletextfield.dart';

class DobField extends StatelessWidget {
  final TextEditingController dobTextController;
  final double width;
  final Function(String)? onFieldSubmitted;
  const DobField(
      {super.key,
      required this.dobTextController,
      required this.width,
      this.onFieldSubmitted});

  @override
  Widget build(BuildContext context) {
    return ReusableTextField(
      title: 'Date of Birth',
      hintText: 'Enter Your Date of Birth',
      icon: Icons.calendar_today,
      isPassword: false,
      color: AppColors.greyColor,
      controller: dobTextController,
      isDob: true,
      onFieldSubmitted: onFieldSubmitted,
      validator: (value) => dobValidator(value!),
    );
  }
}

String? dobValidator(String dob) {
  if (dob.isEmpty) {
    return 'Please enter your Date of Birth';
  } else if (dob.isNotEmpty && !RegExp(Patterns.dobPattern).hasMatch(dob)) {
    return 'Invalid Date of Birth format.';
  }
  return null;
}
