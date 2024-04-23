

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:senior/home_page.dart';
import 'package:senior/loading.dart';
import 'package:senior/firebase_options.dart';
import 'package:senior/BookingPage.dart';
import 'package:senior/appointmenthistory.dart';
import 'package:senior/resetpassword.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => const Loading(),
      '/home': (context) => HomePage(),
      '/booking': (context) => BookingPage(),
      '/appointmenthistory': (context) => AppointmentHistory(),
      /*'fogotpassword': (context) => resetpassword(),*/
    },
  ));
}
