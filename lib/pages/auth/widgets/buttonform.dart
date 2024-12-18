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
    return Container(
      height: 50.0,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Appcolors.mainBlueColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: Ink(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.1,
              vertical: 12.0,
            ),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Appcolors.whiteColor,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
