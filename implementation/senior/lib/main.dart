import 'package:flutter/material.dart';
import 'package:senior/home_page.dart';
import 'package:senior/loading.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute:'/', 
    routes: {
      '/': (context) => Loading(),
      '/home': (context) => HomePage(),
    },

  )
  );
}
