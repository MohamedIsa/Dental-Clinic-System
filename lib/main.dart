import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../const/loading.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';
import 'pages/mainpage/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setPathUrlStrategy();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => const Loading(),
      '/home': (context) => const HomePage(),
    },
  ));
}
