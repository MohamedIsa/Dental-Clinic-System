import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/patients/patient_list.dart';
import 'pages/staff/addstaff/add.dart';
import 'pages/auth/AuthScreen.dart';
import 'pages/settings/settings_screen.dart';
import 'pages/booking/bookingpage.dart';
import 'providers/home_navbar.dart';
import 'providers/patient_navbar.dart';
import 'providers/side_menu_provider.dart';
import 'pages/home/home.dart';
import 'pages/phome/phome.dart';
import 'pages/facultyhome/dashboard.dart';
import 'pages/updateaccount/updateacount.dart';
import 'const/loading.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeNavBarProvider()),
        ChangeNotifierProvider(create: (_) => PatientNavBarProvider()),
        ChangeNotifierProvider(create: (_) => SideMenuProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Loading(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const AuthScreen(
              isSignUp: false,
              isCompleteDetails: false,
              isForgotPassword: false,
            ),
        '/signup': (context) => const AuthScreen(
              isSignUp: true,
              isCompleteDetails: false,
              isForgotPassword: false,
            ),
        '/complete': (context) => const AuthScreen(
              isSignUp: false,
              isCompleteDetails: true,
              isForgotPassword: false,
            ),
        '/forgot': (context) => const AuthScreen(
              isSignUp: false,
              isCompleteDetails: false,
              isForgotPassword: true,
            ),
        '/patientDashboard': (context) => WelcomePage(),
        '/update': (context) => UpdateAccountPage(),
        '/dashboard': (context) => Dashboard(),
        '/settings': (context) => SettingsScreen(),
        '/addstaff': (context) => Add(
              title: 'Add New Staff',
              show: true,
              add: 'Add Staff',
            ),
        '/patients': (context) => PatientScreen(),
        '/addpatient': (context) => Add(
              title: 'Add New Patient',
              show: false,
              add: 'Add Patient',
            ),
        '/booking': (context) => BookingPage(),
      },
    );
  }
}
