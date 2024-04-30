import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:senior/app_colors.dart';
import 'package:senior/app_icons.dart';
import 'package:senior/app_styles.dart';
import 'package:senior/dashboard.dart';
import 'package:senior/responsive_widget.dart';
import 'package:senior/reuseable_widget.dart';

class Complete extends StatefulWidget {
  final String uid;
  const Complete({Key? key, required this.uid}) : super(key: key);

  @override
  _CompleteState createState() => _CompleteState();
}

class _CompleteState extends State<Complete> {
  final TextEditingController _FullnameTextController = TextEditingController();
  final TextEditingController _cprTextController = TextEditingController();
  final TextEditingController _PhoneTextController = TextEditingController();
  final TextEditingController _DOBTextController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedGender = 'Male';
  String CPRPattern = r'^\d{2}(0[1-9]|1[0-2])\d{5}$';
  String PhonePattern = r'^(66\d{6}|3[2-9]\d{6})$';
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backColor,
      body: SizedBox(
        height: height,
        width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ResponsiveWidget.isSmallScreen(context)
                ? const SizedBox()
                : Expanded(
                    child: Container(
                      height: height,
                      color: AppColors.mainBlueColor,
                      child: Center(
                        child: Text(
                          'Dental Clinic',
                          style: ralewayStyle.copyWith(
                            fontSize: 48.0,
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
            Expanded(
              child: Container(
                height: height,
                margin: EdgeInsets.symmetric(
                  horizontal: ResponsiveWidget.isSmallScreen(context)
                      ? height * 0.032
                      : height * 0.12,
                ),
                color: AppColors.backColor,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.2),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Let’s',
                              style: ralewayStyle.copyWith(
                                fontSize: 25.0,
                                color: AppColors.blueDarkColor,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            TextSpan(
                              text: ' Complete details 👇',
                              style: ralewayStyle.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.blueDarkColor,
                                fontSize: 25.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Text(
                        'Hey, Complete Your details to register to the Clinic.',
                        style: ralewayStyle.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: height * 0.064),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Full Name',
                          style: ralewayStyle.copyWith(
                            fontSize: 12.0,
                            color: AppColors.blueDarkColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                        height: 50.0,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: AppColors.whiteColor,
                        ),
                        child: ReusableTextField('Enter Full Name',
                            AppIcons.userIcon, false, _FullnameTextController),
                      ),
                      SizedBox(height: height * 0.014),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Phone Number',
                          style: ralewayStyle.copyWith(
                            fontSize: 12.0,
                            color: AppColors.blueDarkColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                          height: 50.0,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: AppColors.whiteColor,
                          ),
                          child: ReusableTextField('Enter Your phone number',
                              AppIcons.phoneIcon, false, _PhoneTextController)),
                      SizedBox(height: height * 0.014),
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
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value.toString();
                              });
                            },
                          ),
                          Text('Male'),
                          SizedBox(
                            width: width * 0.014,
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
                      SizedBox(height: height * 0.014),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'CPR Number',
                          style: ralewayStyle.copyWith(
                            fontSize: 12.0,
                            color: AppColors.blueDarkColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                        height: 50.0,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: AppColors.whiteColor,
                        ),
                        child: ReusableTextField('Enter Your CPR number',
                            AppIcons.idicon, false, _cprTextController),
                      ),
                      SizedBox(height: height * 0.014),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Date of Birth',
                          style: ralewayStyle.copyWith(
                            fontSize: 12.0,
                            color: AppColors.blueDarkColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                        height: 50.0,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: AppColors.whiteColor,
                        ),
                        child: ReusableTextField('Enter Your Date of Birth',
                            AppIcons.birthIcon, false, _DOBTextController),
                      ),
                      SizedBox(height: height * 0.03),
                      Container(
                        height: 50.0,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: AppColors.mainBlueColor,
                        ),
                        child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                                onTap: () async {
                                  String fullName =
                                      _FullnameTextController.text;
                                  String cpr = _cprTextController.text;
                                  String Phone = _PhoneTextController.text;

                                  if (fullName.isEmpty) {
                                    showErrorDialog(
                                        context, 'Full name cannot be empty.');
                                    return;
                                  }

                                  if (!RegExp(PhonePattern).hasMatch(Phone)) {
                                    showErrorDialog(
                                        context, 'Invalid Phone format.');
                                    return;
                                  }
                                  if (!RegExp(CPRPattern).hasMatch(cpr)) {
                                    showErrorDialog(
                                        context, 'Invalid CPR format.');
                                    return;
                                  }

                                  QuerySnapshot result = await _firestore
                                      .collection('user')
                                      .where('CPR', isEqualTo: cpr)
                                      .get();
                                  if (result.docs.isNotEmpty) {
                                    showErrorDialog(
                                        context, 'CPR already exists.');
                                    return;
                                  }
                                  try {
                                    // Get the current user
                                    User? currentUser =
                                        FirebaseAuth.instance.currentUser;

                                    // Check if the user is signed in
                                    if (currentUser != null) {
                                      // Update the user document with new fields
                                      await _firestore
                                          .collection('user')
                                          .doc(currentUser.uid)
                                          .set(
                                        {
                                          'Email': currentUser.email,
                                          'FullName': fullName,
                                          'CPR': cpr,
                                          'Phone': Phone,
                                          'Gender': _selectedGender,
                                          'DOB': _DOBTextController.text,
                                        },
                                        SetOptions(merge: true),
                                      );

                                      // Add UID to the 'patient' collection
                                      await _firestore
                                          .collection('patient')
                                          .doc(currentUser.uid)
                                          .set({
                                        'UID': currentUser.uid,
                                      });

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => WelcomePage(),
                                        ),
                                      );
                                    } else {
                                      showErrorDialog(context,
                                          'No user is currently signed in.');
                                    }
                                  } catch (e) {
                                    print('Failed to update user: $e');
                                    showErrorDialog(context, e.toString());
                                  }
                                },
                                borderRadius: BorderRadius.circular(16.0),
                                child: Ink(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width *
                                        0.1, // Adjust the horizontal padding as needed
                                    vertical:
                                        12.0, // Adjust the vertical padding as needed
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Complete Registration',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.whiteColor,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ))),
                      ),
                    ],
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
