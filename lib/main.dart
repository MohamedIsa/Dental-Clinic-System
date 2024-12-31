import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../const/loading.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';
import 'pages/auth/AuthScreen.dart';
import 'pages/home/home.dart';
import 'pages/phome/phome.dart';
import 'firebase_options.template.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print(
        'firebase_options.dart not found, using firebase_options.template.dart');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptionsTemplate.currentPlatform,
    );
  }
  setPathUrlStrategy();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
    },
  ));
}
