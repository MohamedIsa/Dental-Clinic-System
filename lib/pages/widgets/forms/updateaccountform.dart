import 'package:flutter/material.dart';
import 'package:senior/const/app_colors.dart';
import 'package:senior/pages/widgets/textfieldwidgets/dobfield.dart';
import 'package:senior/pages/widgets/textfieldwidgets/fullnamefield.dart';
import 'package:senior/pages/widgets/textfieldwidgets/genderfield.dart';
import 'package:senior/pages/widgets/textfieldwidgets/phonefield.dart';

import '../../../functions/updateaccount/checkfields.dart';
import '../textfieldwidgets/cprfield.dart';

class UpdateAccountForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController cprController;
  final TextEditingController dobController;
  final TextEditingController selectedGender;
  final TextEditingController phoneController;
  const UpdateAccountForm(
      {super.key,
      required this.nameController,
      required this.cprController,
      required this.dobController,
      required this.selectedGender,
      required this.phoneController});

  @override
  State<UpdateAccountForm> createState() => _UpdateAccountFormState();
}

class _UpdateAccountFormState extends State<UpdateAccountForm> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            NameField(
              fullNameTextController: widget.nameController,
              width: width,
            ),
            SizedBox(height: height * 0.014),
            CprField(
              cprTextController: widget.cprController,
              width: width,
            ),
            SizedBox(height: height * 0.014),
            DobField(
              dobTextController: widget.dobController,
              width: width,
            ),
            SizedBox(height: height * 0.014),
            GenderField(
                width: width, selectedGender: widget.selectedGender.text),
            SizedBox(height: height * 0.014),
            Phonefield(
              phoneTextController: widget.phoneController,
              width: width,
            ),
            SizedBox(height: height * 0.014),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => checkFields(
                    context,
                    widget.nameController,
                    widget.cprController,
                    widget.dobController,
                    widget.selectedGender,
                    widget.phoneController),
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(AppColors.primaryColor),
                ),
                child: Text('Update',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            )
          ],
        ));
  }
}
