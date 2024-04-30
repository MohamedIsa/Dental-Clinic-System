import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:senior/appointment_screen.dart';
import 'package:senior/dashboard.dart';
import 'package:senior/home_page.dart';
import 'package:senior/loading.dart';
import 'package:senior/firebase_options.dart';
import 'package:senior/bookingpage.dart';
import 'package:senior/appointmenthistory.dart';
import 'package:senior/login_screen.dart';
import 'package:senior/main_screen.dart';
import 'package:senior/patient_screen.dart';
import 'package:senior/reports_screen.dart';
import 'package:senior/resetpassword.dart';
import 'package:senior/completedetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:senior/settings_widget.dart';
import 'package:senior/signup_screen.dart';
import 'package:senior/mobile.dart';
import 'package:senior/treatment_record_screen.dart';

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
      /*'updateaccount':(context) => Update(),*/
      '/admin': (context) => const MainScreen(),
      '/appointment': (context) => const AppointmentPage(),
      '/patients': (context) => AdminPatientPage(),
      '/treatment': (context) => TreatmentRecordScreen(),
      '/reports': (context) => const ReportsScreen(),
      '/settings': (context) => SettingsPage(),
    },
  ));
}
