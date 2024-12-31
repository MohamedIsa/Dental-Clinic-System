import 'package:flutter/material.dart';
import '../../const/app_colors.dart';
import '../../const/app_styles.dart';

class GenderField extends StatefulWidget {
  final double width;
  final String selectedGender;

  const GenderField(
      {super.key, required this.width, required this.selectedGender});

  @override
  State<GenderField> createState() => _GenderFieldState();
}

class _GenderFieldState extends State<GenderField> {
  String _selectedGender = 'Male';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: ralewayStyle.copyWith(
            fontSize: 12.0,
            color: Appcolors.blueDarkColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          children: [
            Radio(
              value: 'Male',
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value.toString();
                });
              },
            ),
            Text('Male'),
            SizedBox(
              width: widget.width * 0.014,
            ),
            Radio(
              value: 'Female',
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value.toString();
                });
              },
            ),
            Text('Female'),
          ],
        ),
      ],
    );
  }
}
