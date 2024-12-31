import 'package:flutter/material.dart';
import 'package:senior/const/app_styles.dart';
import '../../const/app_colors.dart';
import '../../utils/reuseable_widget.dart';

class CprField extends StatelessWidget {
  final TextEditingController cprTextController;
  final double width;
  const CprField(
      {super.key, required this.cprTextController, required this.width});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'CPR Number',
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
            hintText: 'Enter Your CPR number',
            icon: Icons.credit_card,
            isPassword: false,
            color: Appcolors.greyColor,
            controller: cprTextController,
            isNumeric: true,
          ),
        ),
      ],
    );
  }
}
