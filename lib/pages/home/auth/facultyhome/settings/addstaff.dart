import 'package:flutter/material.dart';
import 'package:senior/const/app_colors.dart';
import 'package:senior/pages/widgets/textfieldwidgets/cprfield.dart';
import 'package:senior/pages/widgets/textfieldwidgets/dobfield.dart';
import 'package:senior/pages/widgets/textfieldwidgets/emailfield.dart';
import 'package:senior/pages/widgets/textfieldwidgets/fullnamefield.dart';
import 'package:senior/pages/widgets/textfieldwidgets/genderfield.dart';
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
  String selectedGender = 'Male';
  String selectedRole = 'admin';

  @override
  void dispose() {
    emailTextController.dispose();
    fullNameTextController.dispose();
    cprTextController.dispose();
    dobTextController.dispose();
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
              EmailField(emailTextController: emailTextController),
              const SizedBox(height: 20),
              NameField(
                  fullNameTextController: fullNameTextController, width: width),
              const SizedBox(height: 20),
              CprField(cprTextController: cprTextController, width: width),
              const SizedBox(height: 20),
              DobField(dobTextController: dobTextController, width: width),
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
                    onPressed: () {},
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
