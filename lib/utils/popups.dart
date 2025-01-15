import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

import '../const/app_colors.dart';

void showErrorDialog(BuildContext context, String message) {
  if (kIsWeb) {
    html.window.alert(message);
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kIsWeb ? 0 : 15),
          ),
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                iconColor: kIsWeb ? AppColors.primaryColor : Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

void showMessagealert(BuildContext context, String message) {
  if (kIsWeb) {
    html.window.alert(message);
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kIsWeb ? 0 : 15),
          ),
          title: const Text('Message'),
          content: Text(message),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                iconColor: kIsWeb ? AppColors.primaryColor : Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
