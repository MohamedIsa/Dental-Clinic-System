import 'package:flutter/material.dart';
import '../../../const/app_colors.dart';
import '../../../functions/auth/checkauthfield.dart';
import '../../../utils/data.dart';
import '../../widgets/textfieldwidgets/cprfield.dart';
import '../../widgets/textfieldwidgets/dobfield.dart';
import '../../widgets/textfieldwidgets/emailfield.dart';
import '../../widgets/textfieldwidgets/fullnamefield.dart';
import '../../widgets/textfieldwidgets/genderfield.dart';
import '../../widgets/textfieldwidgets/phonefield.dart';
import '../../widgets/textfieldwidgets/rolefield.dart';

class Add extends StatefulWidget {
  final String title;
  final bool show;
  final String add;
  const Add(
      {super.key, required this.title, required this.show, required this.add});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController fullNameTextController = TextEditingController();
  final TextEditingController cprTextController = TextEditingController();
  final TextEditingController dobTextController = TextEditingController();
  final TextEditingController phoneTextController = TextEditingController();
  String selectedGender = 'Male';
  String selectedRole = 'Admin';

  @override
  void initState() {
    Data.checkUserAndNavigate(context);
    super.initState();
  }

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
          widget.title,
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
              GenderField(
                width: width,
                selectedGender: selectedGender,
                onGenderChanged: (newGender) {
                  setState(() {
                    selectedGender = newGender;
                  });
                },
              ),
              const SizedBox(height: 20),
              widget.show
                  ? Column(
                      children: [
                        RoleField(
                          selectedRole: selectedRole,
                          width: width,
                          onRoleChanged: (newRole) {
                            setState(() {
                              selectedRole = newRole;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    )
                  : Container(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
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
                    child: Text(widget.add),
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
