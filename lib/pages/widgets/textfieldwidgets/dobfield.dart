import 'package:flutter/material.dart';
import 'package:senior/const/app_styles.dart';

import '../../../const/app_colors.dart';
import '../../../utils/reuseable_widget.dart';

class DobField extends StatelessWidget {
  final TextEditingController dobTextController;
  final double width;
  const DobField(
      {super.key, required this.dobTextController, required this.width});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'Date of Birth',
            style: ralewayStyle.copyWith(
              fontSize: 12.0,
              color: AppColors.blueDarkColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 6.0),
        Container(
          height: 50.0,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: AppColors.whiteColor,
          ),
          child: ReusableTextField(
            hintText: 'Enter Your Date of Birth',
            icon: Icons.calendar_today,
            isPassword: false,
            color: AppColors.greyColor,
            controller: dobTextController,
            isDob: true,
          ),
        ),
      ],
    );
  }
}
