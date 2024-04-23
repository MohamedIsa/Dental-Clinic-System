import 'package:flutter/material.dart';
import 'package:senior/app_colors.dart';
import 'package:senior/app_icons.dart';
import 'package:senior/app_styles.dart';
import 'package:senior/login_screen.dart';
import 'package:senior/responsive_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:senior/reuseable_widget.dart';
import 'package:senior/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _FullnameTextController = TextEditingController();
  final TextEditingController _cprTextController = TextEditingController();
  final TextEditingController _PhoneTextController = TextEditingController();
  final TextEditingController _confirmpasswordTextController =
      TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedGender = 'Male';
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    String emailPattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    String CPRPattern = r'^\d{2}(0[1-9]|1[0-2])\d{5}$';
    String PhonePattern = r'^(66\d{6}|3[2-9]\d{6})$';

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
                              text: ' Sign Up 👇',
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
                        'Hey, Enter your details to create a new account.',
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
                          'Email',
                          style: ralewayStyle.copyWith(
                            fontSize: 12.0,
                            color: AppColors.blueDarkColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: AppColors.whiteColor,
                        ),
                        child: ReusableTextField('Enter email',
                            AppIcons.emailIcon, false, _emailTextController),
                      ),
                      SizedBox(height: height * 0.014),
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
                          'CPR',
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
                          child: ReusableTextField('Enter CPR', AppIcons.idicon,
                              false, _cprTextController)),
                      SizedBox(height: height * 0.014),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Password',
                          style: ralewayStyle.copyWith(
                            fontSize: 12.0,
                            color: AppColors.blueDarkColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: AppColors.whiteColor,
                        ),
                        child: ReusableTextField('Enter password',
                            AppIcons.lockIcon, true, _passwordTextController),
                      ),
                      SizedBox(height: height * 0.014),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Confirnm Password',
                          style: ralewayStyle.copyWith(
                            fontSize: 12.0,
                            color: AppColors.blueDarkColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: AppColors.whiteColor,
                        ),
                        child: ReusableTextField(
                            'Confirm password',
                            AppIcons.lockIcon,
                            true,
                            _confirmpasswordTextController),
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
                                  String email = _emailTextController.text;
                                  String fullName =
                                      _FullnameTextController.text;
                                  String cpr = _cprTextController.text;
                                  String password =
                                      _passwordTextController.text;
                                  String Phone = _PhoneTextController.text;

                                  // Check if email is valid
                                  if (!RegExp(emailPattern).hasMatch(email)) {
                                    showErrorDialog(
                                        context, 'Invalid email format.');
                                    return;
                                  }

                                  QuerySnapshot emailResult = await _firestore
                                      .collection('user')
                                      .where('Email', isEqualTo: email)
                                      .get();
                                  if (emailResult.docs.isNotEmpty) {
                                    showErrorDialog(
                                        context, 'Email already exists.');
                                    return;
                                  }

                                  // Check if full name is not empty
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

                                  if (password.isNotEmpty) {
                                    bool hasUppercase =
                                        password.contains(RegExp(r'[A-Z]'));
                                    bool hasLowercase =
                                        password.contains(RegExp(r'[a-z]'));
                                    bool hasDigit =
                                        password.contains(RegExp(r'[0-9]'));
                                    bool hasMinLength = password.length >= 8;

                                    if (!hasUppercase) {
                                      showErrorDialog(context,
                                          'Password must contain at least one uppercase letter.');
                                      return;
                                    }

                                    if (!hasLowercase) {
                                      showErrorDialog(context,
                                          'Password must contain at least one lowercase letter.');
                                      return;
                                    }

                                    if (!hasDigit) {
                                      showErrorDialog(context,
                                          'Password must contain at least one digit.');
                                      return;
                                    }

                                    if (!hasMinLength) {
                                      showErrorDialog(context,
                                          'Password must be at least 8 characters long.');
                                      return;
                                    }
                                  } else {
                                    showErrorDialog(
                                        context, 'Password cannot be empty.');
                                    return;
                                  }
                                  if (password !=
                                      _confirmpasswordTextController.text) {
                                    showErrorDialog(
                                        context, 'Passwords do not match.');
                                    return;
                                  }
                                  try {
                                    UserCredential userCredential =
                                        await FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                      email: email,
                                      password: password,
                                    );

                                    print('User created successfully');

                                    String uid = userCredential.user!.uid;
                                    _firestore.collection('user').doc(uid).set({
                                      'Email': email,
                                      'FullName': fullName,
                                      'CPR': cpr,
                                      'Phone': Phone,
                                      'Gender': _selectedGender,
                                    });

                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => WelcomePage(),
                                      ),
                                    );
                                  } catch (e) {
                                    print('Failed to create user: $e');
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
                                      'Sign Up',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.whiteColor,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ))),
                      ),
                      SizedBox(height: height * 0.02),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Already have an account?',
                            style: ralewayStyle.copyWith(
                              fontSize: 12.0,
                              color: AppColors.mainBlueColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.05),
                      Center(
                        child: Text(
                          'Or Sign Up With',
                          style: ralewayStyle.copyWith(
                            fontSize: 12.0,
                            color: AppColors.greyColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      SizedBox(height: height * 0.02),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 50.0,
                              width: 50.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: AppColors.mainBlueColor,
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                  AppIcons.facebookIcon,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Container(
                              height: 50.0,
                              width: 50.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: AppColors.mainBlueColor,
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                  AppIcons.googleIcon,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ],
                        ),
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
