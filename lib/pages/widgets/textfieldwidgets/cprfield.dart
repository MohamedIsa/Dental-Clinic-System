import 'package:flutter/material.dart';
import '../../../const/app_colors.dart';
import '../../../functions/auth/exists.dart';
import '../../../functions/auth/patterns.dart';
import '../../../utils/reuseabletextfield.dart';

class CprField extends StatefulWidget {
  final TextEditingController cprTextController;
  final double width;
  final Function(String)? onFieldSubmitted;
  const CprField(
      {super.key,
      required this.cprTextController,
      required this.width,
      this.onFieldSubmitted});

  @override
  State<CprField> createState() => _CprFieldState();
}

class _CprFieldState extends State<CprField> {
  String? asyncError;

  Future<void> validateCpr(String cpr) async {
    final result = await cprValidator(cpr);
    setState(() {
      asyncError = result.isNotEmpty ? result : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReusableTextField(
      title: 'CPR Number',
      hintText: 'Enter Your CPR number',
      icon: Icons.credit_card,
      isPassword: false,
      color: AppColors.greyColor,
      controller: widget.cprTextController,
      isNumeric: true,
      onFieldSubmitted: (value) {
        validateCpr(value);
        widget.onFieldSubmitted?.call(value);
      },
      validator: (value) => cprValidatorSync(value!),
    );
  }
}

String? cprValidatorSync(String cpr) {
  if (cpr.isEmpty) {
    return 'Please enter your CPR number';
  } else if (cpr.length != 9) {
    return 'CPR number must be 9 digits';
  } else if (!RegExp(Patterns.cprPattern).hasMatch(cpr)) {
    return 'Invalid CPR format.';
  }
  return null;
}

Future<String> cprValidator(String cpr) async {
  String? result = cprValidatorSync(cpr);
  if (result != null) {
    return result;
  } else if (await cprExists(cpr)) {
    return 'CPR already exists.';
  }
  return '';
}
