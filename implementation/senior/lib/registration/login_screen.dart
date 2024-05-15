import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:senior/app_colors.dart';
import 'package:senior/app_icons.dart';
import 'package:senior/app_styles.dart';
import 'package:senior/responsive_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senior/reuseable_widget.dart';
import 'package:senior/registration/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
  }

  // Method to check if the user is already logged in
  Future<void> checkUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId');

    if (userId != null) {
      DocumentSnapshot patientSnapshot = await FirebaseFirestore.instance.collection('patient').doc(userId).get();
      if (patientSnapshot.exists) {
        // User is a patient, redirect to the patient dashboard.
        Navigator.pushNamed(context, '/dashboard');
      } else {
        // Check if the user exists in the admin collection.
        DocumentSnapshot adminSnapshot = await FirebaseFirestore.instance.collection('admin').doc(userId).get();
        if (adminSnapshot.exists) {
          // User is an admin, redirect to the admin page.
          Navigator.pushNamed(context, '/admin');
        } else {
          showErrorDialog(context, 'User not found in patient or admin collection');
        
    }
  }
    }
  }
  // Method to persist user ID locally
  Future<void> persistUser(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

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
                        color:  Colors.lightBlue,
                      child: Center(
                        child: Container(
                            child: Image.asset(
                            'assets/images/logo.png',
                            width: width*0.4,
                            height: height*0.4,
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
                              text: ' Sign In 👇',
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
                        'Hey, Enter your details to get sign in \nto your account.',
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
                      SizedBox(height:20),
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
                        child: ReusableTextField('Enter password', AppIcons.lockIcon, true, _passwordTextController)
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
                              try {
                                UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                  email: _emailTextController.text,
                                  password: _passwordTextController.text,
                                );

                                if (userCredential.user != null) {
                                  // Persist the user's ID locally.
                                  await persistUser(userCredential.user!.uid);

                                  // Check if the user exists in the patient collection.
                                  DocumentSnapshot patientSnapshot = await FirebaseFirestore.instance.collection('patient').doc(userCredential.user!.uid).get();
                                  if (patientSnapshot.exists) {
                                    // User is a patient, redirect to the patient dashboard.
                                    Navigator.pushNamed(context, '/dashboard');
                                  } else {
                                    // Check if the user exists in the admin collection.
                                    DocumentSnapshot adminSnapshot = await FirebaseFirestore.instance.collection('admin').doc(userCredential.user!.uid).get();
                                    if (adminSnapshot.exists) {
                                      // User is an admin, redirect to the admin page.
                                      Navigator.pushNamed(context, '/admin');
                                    } else {
                                      showErrorDialog(context, 'User not found in patient or admin collection');
                                    }
                                  }
                                }
                              } catch (e) {
                                if (_emailTextController.text == '' || _passwordTextController.text == '') {
                                  showErrorDialog(context, 'Please fill all the fields');
                                } else if (_emailTextController.text != FirebaseAuth.instance.currentUser!.email) {
                                  showErrorDialog(context, 'Invalid email');
                                } else if (_passwordTextController.text != FirebaseAuth.instance.currentUser!.email) {
                                  showErrorDialog(context, 'Invalid password');
                                } else {
                                  showErrorDialog(context, 'Unknown error occurred. Please try again.');
                                }
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
                                  'Sign In',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.whiteColor,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgotpassword');
                          },
                          child: Text(
                            'Forgot Password?',
                            style: ralewayStyle.copyWith(
                              fontSize: 12.0,
                              color: AppColors.mainBlueColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 11.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Don’t have an account? ',
                              style: ralewayStyle.copyWith(
                                fontSize: 12.0,
                                color: AppColors.greyColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const SignUp(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Sign Up',
                                  style: ralewayStyle.copyWith(
                                    fontSize: 12.0,
                                    color: AppColors.mainBlueColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.05),
                      Center(
                        child: Text('Or Sign In With',
                            style: ralewayStyle.copyWith(
                              fontSize: 12.0,
                              color: AppColors.greyColor,
                              fontWeight: FontWeight.w600,
                            )),
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
                                onPressed: () async {
                                   await signInWithGoogle(context);
                                },
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