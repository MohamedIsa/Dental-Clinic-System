import 'package:flutter/material.dart';

import '../../../const/app_colors.dart';
import '../../../const/app_styles.dart';

class RoleField extends StatefulWidget {
  final String selectedRole;
  final double width;
  final ValueChanged<String> onRoleChanged;

  const RoleField({
    super.key,
    required this.selectedRole,
    required this.width,
    required this.onRoleChanged,
  });

  @override
  RoleFieldState createState() => RoleFieldState();
}

class RoleFieldState extends State<RoleField> {
  late String _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole =
        ['Admin', 'Receptionist', 'Dentist'].contains(widget.selectedRole)
            ? widget.selectedRole
            : 'Admin';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'Select Role',
            style: ralewayStyle.copyWith(
              fontSize: 12.0,
              color: AppColors.blueDarkColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 6.0),
        Container(
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: AppColors.whiteColor,
          ),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            ),
            value: _selectedRole,
            items: ['Admin', 'Receptionist', 'Dentist'].map((role) {
              return DropdownMenuItem<String>(
                value: role,
                child: Text(role),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedRole = newValue!;
                widget.onRoleChanged(_selectedRole);
              });
            },
          ),
        ),
      ],
    );
  }
}
