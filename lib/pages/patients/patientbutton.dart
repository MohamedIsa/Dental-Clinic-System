import 'package:flutter/material.dart';

class PatientButtonsWidget extends StatefulWidget {
  final VoidCallback? onAddPatientPressed;
  final void Function(String cpr)? onSearchPatientPressed;

  const PatientButtonsWidget({
    super.key,
    this.onAddPatientPressed,
    this.onSearchPatientPressed,
  });

  @override
  _PatientButtonsWidgetState createState() => _PatientButtonsWidgetState();
}

class _PatientButtonsWidgetState extends State<PatientButtonsWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonTheme(
                minWidth: 120,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/addpatient'),
                  child: const Text('Add New Patient'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
