import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

void showErrorDialog(BuildContext context, String message) {
  if (kIsWeb) {
    html.window.alert(message);
  } else {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'OK',
          onPressed: scaffold.hideCurrentSnackBar,
          textColor: Colors.white,
        ),
      ),
    );
  }
}

void showMessagealert(BuildContext context, String message) {
  if (kIsWeb) {
    html.window.alert(message);
  } else {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'OK',
          onPressed: scaffold.hideCurrentSnackBar,
          textColor: Colors.white,
        ),
      ),
    );
  }
}
