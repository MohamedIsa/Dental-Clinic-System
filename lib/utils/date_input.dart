import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll('/', '');
    final newText = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if ((i == 2 || i == 4) && i != 0) newText.write('/');
      newText.write(text[i]);
    }
    return TextEditingValue(
        text: newText.toString(),
        selection: TextSelection.collapsed(offset: newText.length));
  }
}
