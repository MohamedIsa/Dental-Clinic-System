import 'package:adminpage/const/constant.dart';
import 'package:adminpage/screens/appointment_screen/appointment_screen.dart';
import 'package:adminpage/screens/firebase_options.dart';
import 'package:adminpage/screens/main_screen/main_screen.dart';
import 'package:adminpage/screens/patients_screen/patient_screen.dart';
import 'package:adminpage/screens/reports_screen/reports_screen.dart';
import 'package:adminpage/screens/settings_screen/widget/settings_widget.dart';
import 'package:adminpage/screens/treatment_record_screen/treatment_record_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        brightness: Brightness.light,
      ),
      home: const MainScreen(),
      routes: {
    '/dashboard':(context) => const MainScreen(),
    '/appointment': (context) => const AppointmentPage(), 
    '/patients':(context) => AdminPatientPage(),
    '/treatment':(context)=> TreatmentRecordScreen(),
    '/reports':(context)=> const ReportsScreen(),
    '/settings':(context)=> SettingsPage(),
  },
);

  }
}
