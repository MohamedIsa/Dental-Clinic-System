import 'package:flutter/material.dart';
import 'package:senior/functions/auth/checkauthfield.dart';
import 'package:senior/pages/widgets/static/buttonform.dart';
import 'package:senior/pages/widgets/textfieldwidgets/cprfield.dart';
import 'package:senior/pages/widgets/textfieldwidgets/dobfield.dart';
import 'package:senior/pages/widgets/textfieldwidgets/fullnamefield.dart';
import 'package:senior/pages/widgets/textfieldwidgets/genderfield.dart';
import 'package:senior/pages/widgets/textfieldwidgets/phonefield.dart';

class CompleteForm extends StatefulWidget {
  final String uid;
  const CompleteForm({super.key, required this.uid});

  @override
  _CompleteFormState createState() => _CompleteFormState();
}

class _CompleteFormState extends State<CompleteForm> {
  final TextEditingController _fullNameTextController = TextEditingController();
  final TextEditingController _cprTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();
  final TextEditingController _dobTextController = TextEditingController();
  String _selectedGender = 'Male';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NameField(
            fullNameTextController: _fullNameTextController, width: width),
        SizedBox(height: height * 0.014),
        Phonefield(phoneTextController: _phoneTextController, width: width),
        SizedBox(height: height * 0.014),
        GenderField(width: width, selectedGender: _selectedGender),
        SizedBox(height: height * 0.014),
        CprField(cprTextController: _cprTextController, width: width),
        SizedBox(height: height * 0.014),
        DobField(dobTextController: _dobTextController, width: width),
        SizedBox(height: height * 0.03),
        ButtonForm(
            width: width,
            title: 'Complete Registration',
            onTap: () => check(
                  context,
                  widget.uid,
                  null,
                  null,
                  null,
                  _fullNameTextController,
                  _cprTextController,
                  _phoneTextController,
                  _selectedGender,
                  _dobTextController,
                )),
      ],
    );
  }
}
