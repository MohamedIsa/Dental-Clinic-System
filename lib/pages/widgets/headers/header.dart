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
                text: 'Let’s',
                style: ralewayStyle.copyWith(
                  fontSize: 25.0,
                  color: AppColors.blueDarkColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
              TextSpan(
                text: ' ${headerName} 👇',
                style: ralewayStyle.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.blueDarkColor,
                  fontSize: 25.0,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Text(
          message,
          style: ralewayStyle.copyWith(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: AppColors.textColor,
          ),
        ),
      ],
    );
  }
}
