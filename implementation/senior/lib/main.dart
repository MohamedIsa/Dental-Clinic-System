import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:senior/admin/appointment_screen.dart';
import 'package:senior/admin/settings_screen.dart';
import 'package:senior/patient/completedetails.dart';
import 'package:senior/patient/dashboard.dart';
import 'package:senior/patient/home_page.dart';
import 'package:senior/loading.dart';
import 'package:senior/firebase_options.dart';
import 'package:senior/patient/bookingpage.dart';
import 'package:senior/patient/appointmenthistory.dart';
import 'package:senior/patient/updateaccount.dart';
import 'package:senior/registration/login_screen.dart';
import 'package:senior/admin/main_screen.dart';
import 'package:senior/admin/patient_screen.dart';
import 'package:senior/admin/reports_screen.dart';
import 'package:senior/registration/resetpassword.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:senior/registration/signup_screen.dart';
import 'package:senior/patient/mobile.dart';
import 'package:senior/admin/treatment_record_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.authStateChanges().first;

  var firebaseUser = FirebaseAuth.instance.currentUser;
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => const Loading(),
      '/home': (context) => const HomePage(),
      '/booking': (context) => BookingPage(),
      '/appointmenthistory': (context) => AppointmentHistoryPage(),
      '/forgotpassword': (context) => const ResetPasswordPage(),
      '/login': (context) => const LoginScreen(),
      '/completedetails': (context) => Complete(uid: firebaseUser!.uid),
      '/dashboard': (context) => WelcomePage(),
      '/signup': (context) => const SignUp(),
      '/bookingm': (context) => bookingm(),
      '/update': (context) =>  UpdateAccountPage(),
      '/admin': (context) => const MainScreen(),
      '/appointment': (context) => const AppointmentPage(),
      '/patients': (context) => AdminPatientPage(),
      '/treatment': (context) => TreatmentRecordScreen(),
      '/reports': (context) => const ReportsScreen(),
      '/settings': (context) => const SettingsScreen(),
    },
  ));
}