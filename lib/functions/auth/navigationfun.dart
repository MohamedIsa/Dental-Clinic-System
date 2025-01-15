import 'package:flutter/material.dart';

void toggleForm(BuildContext context) {
  Navigator.pushNamed(context, '/signup');
}

void toggleSignIn(BuildContext context) {
  Navigator.pushNamed(context, '/login');
}

void toggleForgotPassword(BuildContext context) {
  Navigator.pushNamed(context, '/forgot');
}

void toggleCompleteDetails(BuildContext context) {
  Navigator.pushNamed(context, '/complete');
}
