import 'package:flutter/material.dart';
import 'package:senior/app_icons.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:universal_html/html.dart' as html;

TextField reusableTextField(String hintText, String iconAssetPath, bool isPassword, TextEditingController controller) {
  bool _obscureText = isPassword;
  return TextField(
    controller: controller,
    obscureText: _obscureText,
    style: TextStyle(
      fontWeight: FontWeight.w400,
      color: Colors.black,
      fontSize: 12.0,
    ),
    decoration: InputDecoration(
      border: InputBorder.none,
      prefixIcon: iconAssetPath.isNotEmpty ? ImageIcon(AssetImage(iconAssetPath)) : null, 
      suffixIcon: isPassword ? IconButton(
        onPressed: () {
          _obscureText = !_obscureText;
        },
        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
      ) : null,
      contentPadding: EdgeInsets.only(top: 16.0),
      hintText: hintText,
      hintStyle: TextStyle(
        fontWeight: FontWeight.w400,
        color: Colors.black.withOpacity(0.5),
        fontSize: 12.0,
      ),
    ),
  );
}

TextField fullNameTextField(TextEditingController controller) {
  return reusableTextField('Full Name', AppIcons.userIcon, false, controller);
}

TextField cprTextField(TextEditingController controller) {
  return reusableTextField('CPR', AppIcons.idicon, false, controller);
}
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