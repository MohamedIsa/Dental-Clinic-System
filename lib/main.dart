import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:senior/pages/updateaccount/updateacount.dart';
import '../const/loading.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';
import 'pages/auth/AuthScreen.dart';
import 'pages/home/home.dart';
import 'pages/phome/phome.dart';

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

  runApp(MaterialApp(
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
    },
  ));
}
