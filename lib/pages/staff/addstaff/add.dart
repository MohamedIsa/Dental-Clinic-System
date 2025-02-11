import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  const Add({
    super.key,
    required this.title,
    required this.show,
    required this.add,
  });

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
  Color selectedColor = Colors.blue;

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
    final isSmallScreen = width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryColor, Colors.white],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16.0 : width * 0.1,
                  vertical: 24.0,
                ),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          widget.show
                              ? 'Staff Information'
                              : 'User Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: 24),
                        EmailField(
                          emailTextController: emailTextController,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        SizedBox(height: 16),
                        NameField(
                          fullNameTextController: fullNameTextController,
                          width: width,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        SizedBox(height: 16),
                        CprField(
                          cprTextController: cprTextController,
                          width: width,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        SizedBox(height: 16),
                        PhoneField(
                          phoneTextController: phoneTextController,
                          width: width,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        SizedBox(height: 16),
                        DobField(
                          dobTextController: dobTextController,
                          width: width,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        SizedBox(height: 16),
                        GenderField(
                          width: width,
                          selectedGender: selectedGender,
                          onGenderChanged: (newGender) {
                            setState(() {
                              selectedGender = newGender;
                            });
                          },
                        ),
                        if (widget.show) ...[
                          SizedBox(height: 24),
                          Text(
                            'Role Settings',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          SizedBox(height: 16),
                          RoleField(
                            selectedRole: selectedRole,
                            width: width,
                            onRoleChanged: (newRole) {
                              setState(() {
                                selectedRole = newRole;
                              });
                            },
                          ),
                          if (selectedRole == 'Dentist') ...[
                            SizedBox(height: 24),
                            Text(
                              'Dentist Color',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            SizedBox(height: 16),
                            ColorPicker(
                              borderColor: AppColors.primaryColor,
                              onColorChanged: (color) {
                                setState(() {
                                  selectedColor = color;
                                });
                              },
                            ),
                          ],
                        ],
                        SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: () => context.go('/dashboard'),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                side: BorderSide(color: AppColors.primaryColor),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {
                                check(
                                  context: context,
                                  emailTextController: emailTextController,
                                  fullNameTextController:
                                      fullNameTextController,
                                  cprTextController: cprTextController,
                                  phoneTextController: phoneTextController,
                                  selectedGender: selectedGender,
                                  dobTextController: dobTextController,
                                  selectedrole: selectedRole,
                                  selectedColor: selectedColor,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                widget.add,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
