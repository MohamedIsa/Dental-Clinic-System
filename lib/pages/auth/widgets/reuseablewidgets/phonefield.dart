import 'package:flutter/material.dart';

import '../../../../const/app_colors.dart';
import '../../../../const/app_styles.dart';
import '../../../../utils/reuseable_widget.dart';

class Phonefield extends StatelessWidget {
  final TextEditingController phoneTextController;
  final double width;
  const Phonefield(
      {super.key, required this.phoneTextController, required this.width});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'Phone Number',
            style: ralewayStyle.copyWith(
              fontSize: 12.0,
              color: Appcolors.blueDarkColor,
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
            color: Appcolors.whiteColor,
          ),
          child: ReusableTextField(
            hintText: 'Enter Your phone number',
            icon: Icons.phone,
            isPassword: false,
            color: Appcolors.greyColor,
            controller: phoneTextController,
            isNumeric: true,
          ),
        ),
      ],
    );
  }
}
