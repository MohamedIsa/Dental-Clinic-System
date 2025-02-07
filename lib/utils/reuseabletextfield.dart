import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../const/app_colors.dart';
import 'date_input.dart';

class ReusableTextField extends StatefulWidget {
  final String title;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final Color color;
  final TextEditingController controller;
  final bool isNumeric;
  final bool isDob;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?) validator;
  final Function(String)? onChanged;

  const ReusableTextField({
    super.key,
    required this.title,
    required this.hintText,
    required this.icon,
    required this.isPassword,
    required this.color,
    required this.controller,
    this.isNumeric = false,
    this.isDob = false,
    this.onFieldSubmitted,
    required this.validator,
    this.onChanged,
  });

  @override
  ReusableTextFieldState createState() => ReusableTextFieldState();
}

class ReusableTextFieldState extends State<ReusableTextField> {
  late bool _obscureText;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _handleChange(String value) {
    final error = widget.validator(value);
    setState(() {
      hasError = error != null && error.isNotEmpty;
    });
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 12.0,
              color: AppColors.blueDarkColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 6.0),
        Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      BorderSide(color: hasError ? Colors.red : Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      BorderSide(color: hasError ? Colors.red : Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: hasError ? Colors.red : Colors.blue, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
                prefixIcon: Icon(widget.icon, color: widget.color),
                suffixIcon: widget.isPassword
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 12.0),
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 14.0,
                ),
                errorStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onFieldSubmitted: widget.onFieldSubmitted,
              validator: (value) {
                final error = widget.validator(value);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      hasError = error != null && error.isNotEmpty;
                    });
                  }
                });
                return error;
              },
            )),
      ],
    );
  }
}
