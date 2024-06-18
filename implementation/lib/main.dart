import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:senior/aboutus.dart';
import 'package:senior/admin/appointment_screen.dart';
import 'package:senior/admin/settings_screen.dart';
import 'package:senior/dentist/dentist_main_screen.dart';
import 'package:senior/dentist/patient_screen.dart';
import 'package:senior/dentist/treatment_record_screen.dart';
import 'package:senior/receptionist/appointment_screen.dart';
import 'package:senior/receptionist/main_screen.dart';
import 'package:senior/receptionist/patient_screen.dart';
import 'package:senior/registration/completedetails.dart';
import 'package:senior/patient/dashboard.dart';
import 'package:senior/patient/home_page.dart';
import 'package:senior/loading.dart';
import 'package:senior/patient/bookingpage.dart';
import 'package:senior/patient/appointmenthistory.dart';
import 'package:senior/patient/updateaccount.dart';
import 'package:senior/patient/updateappointment.dart';
import 'package:senior/patient/updateappomob.dart';
import 'package:senior/registration/login_screen.dart';
import 'package:senior/admin/main_screen.dart';
import 'package:senior/admin/patient_screen.dart';
import 'package:senior/registration/resetpassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:senior/registration/signup_screen.dart';
import 'package:senior/patient/mobile.dart';
import 'package:senior/patient/editappointment.dart';
import 'package:senior/services.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  FirebaseOptions firebaseOptions = const FirebaseOptions(
    apiKey: 'AIzaSyCuKUvQ9nZXLUF0NqsFDXSdGHwToawxyvQ',
    appId: '1:351146855860:android:1d460bb507f7170d9276e1',
    messagingSenderId: '351146855860',
    projectId: 'endless-set-314517',
    authDomain: 'endless-set-314517.firebaseapp.com',
    storageBucket: 'endless-set-314517.appspot.com',
    databaseURL:
        'https://endless-set-314517-default-rtdb.asia-southeast1.firebasedatabase.app',
    measurementId: 'G-Z479E0VRMN',
  );
  await Firebase.initializeApp(
    options: firebaseOptions,
  );
  await FirebaseAuth.instance.authStateChanges().first;

  var firebaseUser = FirebaseAuth.instance.currentUser;
  setPathUrlStrategy();
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
      '/update': (context) => UpdateAccountPage(),
      '/admin': (context) => const MainScreen(),
      '/receptionist': (context) => const ReceptionistMainScreen(),
      '/dentist': (context) => const DentistMainScreen(),
      '/appointment': (context) => const AppointmentPage(),
      '/appointment_receptionist': (context) =>
          const ReceptionistAppointmentPage(),
      '/patients': (context) => AdminPatientPage(),
      '/patients_Receptionist': (context) => ReceptionistPatientPage(),
      '/patients_dentist': (context) => DentistPatientPage(),
      '/treatment': (context) => TreatmentRecordScreen(),
      '/settings': (context) => const SettingsScreen(),
      '/editappointment': (context) => Editappointment(),
      '/updateappointment': (context) => Updateappointment(),
      '/updateppoim': (context) => Updateappomob(),
      '/aboutus': (context) => const Aboutus(),
      '/service': (context) => Services(),
    },
  ));
}
