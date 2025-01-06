import 'package:flutter/material.dart';
import 'package:senior/const/app_styles.dart';
import '../../../const/app_colors.dart';
import '../../../functions/auth/exists.dart';
import '../../../functions/auth/patterns.dart';
import '../../../utils/reuseable_widget.dart';

class CprField extends StatelessWidget {
  final TextEditingController cprTextController;
  final double width;
  final Function(String)? onFieldSubmitted;
  const CprField(
      {super.key,
      required this.cprTextController,
      required this.width,
      this.onFieldSubmitted});

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
            hintText: 'Enter Your CPR number',
            icon: Icons.credit_card,
            isPassword: false,
            color: AppColors.greyColor,
            controller: cprTextController,
            isNumeric: true,
            onFieldSubmitted: onFieldSubmitted,
          ),
        ),
      ],
    );
  }
}

Future<String> cprValidator(String cpr) async {
  if (cpr.isEmpty) {
    return 'Please enter your CPR number';
  } else if (cpr.length != 9) {
    return 'CPR number must be 9 digits';
  } else if (cpr.isNotEmpty && !RegExp(Patterns.cprPattern).hasMatch(cpr)) {
    return 'Invalid CPR format.';
  } else if (await cprExists(cpr)) {
    return 'CPR already exists.';
  }
  return '';
}
