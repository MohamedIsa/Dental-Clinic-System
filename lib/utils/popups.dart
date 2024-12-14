import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

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
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                iconColor: kIsWeb ? Colors.blue : Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
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
          title: Text('Message'),
          content: Text(message),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                iconColor: kIsWeb ? Colors.blue : Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
