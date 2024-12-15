import 'package:flutter/material.dart';

class ReusableTextField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final Color color;
  final TextEditingController controller;

  ReusableTextField(
      this.hintText, this.icon, this.isPassword, this.color, this.controller);

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
      style: TextStyle(
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
                    _obscureText ? Icons.visibility : Icons.visibility_off),
              )
            : null,
        contentPadding: EdgeInsets.only(top: 16.0),
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
