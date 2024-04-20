

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:senior/home_page.dart';
import 'package:senior/loading.dart';
import 'package:senior/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => Loading(),
      '/home': (context) => HomePage(),
    },
  ));
}
