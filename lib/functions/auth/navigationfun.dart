import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void toggleForm(BuildContext context) {
  context.go('/signup');
}

void toggleSignIn(BuildContext context) {
  context.go('/login');
}

void toggleForgotPassword(BuildContext context) {
  context.go('/forgot');
}

void toggleCompleteDetails(BuildContext context) {
  context.go('/complete');
}
