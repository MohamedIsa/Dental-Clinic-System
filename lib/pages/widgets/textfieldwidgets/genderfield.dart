import 'package:flutter/material.dart';
import '../../../const/app_colors.dart';
import '../../../const/app_styles.dart';

class GenderField extends StatefulWidget {
  final double width;
  final String selectedGender;
  final ValueChanged<String> onGenderChanged;

  const GenderField({
    super.key,
    required this.width,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  State<GenderField> createState() => _GenderFieldState();
}

class _GenderFieldState extends State<GenderField> {
  late String _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.selectedGender;
  }

  @override
  void didUpdateWidget(GenderField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedGender != widget.selectedGender) {
      setState(() {
        _selectedGender = widget.selectedGender;
      });
    }
  }

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
              groupValue: _selectedGender,
              activeColor: AppColors.primaryColor,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value.toString();
                });
                widget.onGenderChanged(value.toString());
              },
            ),
            Text('Male'),
            SizedBox(
              width: widget.width * 0.014,
            ),
            Radio(
              value: 'Female',
              groupValue: _selectedGender,
              activeColor: AppColors.primaryColor,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value.toString();
                });
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
