import 'package:flutter/material.dart';
import '../../../const/app_colors.dart';
import '../../../const/app_styles.dart';

class GenderField extends StatefulWidget {
  final double width;
  final String selectedGender;
  final ValueChanged<String> onGenderChanged;

  GenderField({
    super.key,
    required this.width,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  State<GenderField> createState() => _GenderFieldState();
}

class _GenderFieldState extends State<GenderField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: ralewayStyle.copyWith(
            fontSize: 12.0,
            color: AppColors.blueDarkColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          children: [
            Radio(
              value: 'Male',
              groupValue: widget.selectedGender,
              activeColor: AppColors.primaryColor,
              onChanged: (value) {
                widget.onGenderChanged(value.toString());
              },
            ),
            Text('Male'),
            SizedBox(
              width: widget.width * 0.014,
            ),
            Radio(
              value: 'Female',
              groupValue: widget.selectedGender,
              activeColor: AppColors.primaryColor,
              onChanged: (value) {
                widget.onGenderChanged(value.toString());
              },
            ),
            Text('Female'),
          ],
        ),
      ],
    );
  }
}
