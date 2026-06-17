import 'package:flutter/material.dart';
import 'package:senior/const/app_colors.dart';
import 'package:senior/const/app_styles.dart';

class Header extends StatelessWidget {
  final String headerName;
  final String message;
  const Header({super.key, required this.headerName, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Dental Clinic',
                style: ralewayStyle.copyWith(
                  fontSize: 14.0,
                  color: AppColors.blueDarkColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.0,
                ),
              ),
              TextSpan(
                text: '\n$headerName',
                style: ralewayStyle.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.blueDarkColor,
                  fontSize: 32.0,
                  height: 1.2,
                  letterSpacing: 0.0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          message,
          style: ralewayStyle.copyWith(
            fontSize: 14.0,
            height: 1.5,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor,
          ),
        ),
      ],
    );
  }
}
