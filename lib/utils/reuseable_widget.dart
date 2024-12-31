import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReusableTextField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final Color color;
  final TextEditingController controller;
  final bool isNumeric;
  final bool isDob;

  const ReusableTextField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.isPassword,
    required this.color,
    required this.controller,
    this.isNumeric = false,
    this.isDob = false,
  });

  @override
  _ReusableTextFieldState createState() => _ReusableTextFieldState();
}

class _ReusableTextFieldState extends State<ReusableTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.isNumeric || widget.isDob
          ? TextInputType.number
          : TextInputType.text,
      inputFormatters: widget.isNumeric || widget.isDob
          ? [
              FilteringTextInputFormatter.digitsOnly,
              if (widget.isDob) ...[
                LengthLimitingTextInputFormatter(8),
                DateInputFormatter(),
              ],
            ]
          : null,
      style: const TextStyle(
        fontWeight: FontWeight.w400,
        color: Colors.black,
        fontSize: 14.0,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: Icon(widget.icon, color: widget.color),
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
              )
            : null,
        contentPadding: const EdgeInsets.only(top: 16.0),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.black.withOpacity(0.5),
          fontSize: 14.0,
        ),
      ),
    );
  }
}

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
