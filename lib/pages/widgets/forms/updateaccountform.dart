import 'package:flutter/material.dart';
import '../../../const/app_colors.dart';
import '../../../functions/updateaccount/checkfields.dart';
import '../textfieldwidgets/cprfield.dart';
import '../textfieldwidgets/dobfield.dart';
import '../textfieldwidgets/fullnamefield.dart';
import '../textfieldwidgets/genderfield.dart';
import '../textfieldwidgets/phonefield.dart';

class UpdateAccountForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController cprController;
  final TextEditingController dobController;
  final String selectedGender;
  final TextEditingController phoneController;
  final ValueChanged<String> onGenderChanged;

  UpdateAccountForm({
    super.key,
    required this.nameController,
    required this.cprController,
    required this.dobController,
    required this.selectedGender,
    required this.phoneController,
    required this.onGenderChanged,
  });

  @override
  State<UpdateAccountForm> createState() => _UpdateAccountFormState();
}

class _UpdateAccountFormState extends State<UpdateAccountForm> {
  late String _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.selectedGender;
  }

  @override
  void didUpdateWidget(UpdateAccountForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedGender != widget.selectedGender) {
      setState(() {
        _selectedGender = widget.selectedGender;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                NameField(
                  fullNameTextController: widget.nameController,
                  width: width,
                ),
                const SizedBox(height: 24),
                CprField(
                  cprTextController: widget.cprController,
                  width: width,
                ),
                const SizedBox(height: 24),
                DobField(
                  dobTextController: widget.dobController,
                  width: width,
                ),
                const SizedBox(height: 24),
                GenderField(
                  width: width,
                  selectedGender: _selectedGender,
                  onGenderChanged: (newGender) {
                    setState(() {
                      _selectedGender = newGender;
                    });
                    widget.onGenderChanged(newGender);
                  },
                ),
                const SizedBox(height: 24),
                PhoneField(
                  phoneTextController: widget.phoneController,
                  width: width,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () => checkFields(
              context,
              widget.nameController,
              widget.cprController,
              widget.dobController,
              _selectedGender, // Use the updated selected gender
              widget.phoneController,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
            ),
            child: const Text(
              'Update Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
