import 'package:flutter/material.dart';

import '../../../const/app_colors.dart';

class ButtonForm extends StatelessWidget {
  final double width;
  final String title;
  final VoidCallback onTap;

  const ButtonForm({
    required this.width,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      width: width,
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.whiteColor,
            fontSize: 15.0,
            letterSpacing: 0.0,
          ),
        ),
      ),
    );
  }
}
