import 'package:flutter/material.dart';
import 'package:senior/const/app_colors.dart';
import 'package:senior/functions/auth/checkauthfield.dart';
import 'package:senior/pages/widgets/textfieldwidgets/cprfield.dart';
import 'package:senior/pages/widgets/textfieldwidgets/dobfield.dart';
import 'package:senior/pages/widgets/textfieldwidgets/emailfield.dart';
import 'package:senior/pages/widgets/textfieldwidgets/fullnamefield.dart';
import 'package:senior/pages/widgets/textfieldwidgets/genderfield.dart';
import 'package:senior/pages/widgets/textfieldwidgets/phonefield.dart';
import 'package:senior/pages/widgets/textfieldwidgets/rolefield.dart';

class AddStaff extends StatefulWidget {
  const AddStaff({super.key});

  @override
  State<AddStaff> createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController fullNameTextController = TextEditingController();
  final TextEditingController cprTextController = TextEditingController();
  final TextEditingController dobTextController = TextEditingController();
  final TextEditingController phoneTextController = TextEditingController();
  String selectedGender = 'Male';
  String selectedRole = 'admin';

  @override
  void dispose() {
    emailTextController.dispose();
    fullNameTextController.dispose();
    cprTextController.dispose();
    dobTextController.dispose();
    phoneTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(138, 202, 200, 200),
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Add New Staff',
          style: TextStyle(
            color: AppColors.whiteColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EmailField(
                emailTextController: emailTextController,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              const SizedBox(height: 20),
              NameField(
                fullNameTextController: fullNameTextController,
                width: width,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              const SizedBox(height: 20),
              CprField(
                cprTextController: cprTextController,
                width: width,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              const SizedBox(height: 20),
              Phonefield(
                phoneTextController: phoneTextController,
                width: width,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              const SizedBox(height: 20),
              DobField(
                dobTextController: dobTextController,
                width: width,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              const SizedBox(height: 20),
              GenderField(width: width, selectedGender: selectedGender),
              const SizedBox(height: 20),
              RoleField(
                selectedRole: selectedRole,
                width: width,
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Cancel'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      //print the whole fields first then go to the check function
                      print('Email: ${emailTextController.text}');
                      print('Full Name: ${fullNameTextController.text}');
                      print('CPR: ${cprTextController.text}');
                      print('Phone: ${phoneTextController.text}');
                      print('DOB: ${dobTextController.text}');
                      print('selectedgender: $selectedGender');
                      print('selectedrole: $selectedRole');

                      check(
                        context: context,
                        emailTextController: emailTextController,
                        fullNameTextController: fullNameTextController,
                        cprTextController: cprTextController,
                        phoneTextController: phoneTextController,
                        selectedGender: selectedGender,
                        dobTextController: dobTextController,
                        selectedrole: selectedRole,
                      );
                    },
                    child: Text('Add Staff'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
