import 'package:flutter/material.dart';
import 'package:adminpage/models/patient_model.dart';

class PatientDetailsPage extends StatelessWidget {
  final PatientData patient;

  const PatientDetailsPage({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${patient.fullName}'),
            Text('CPR: ${patient.cpr}'),
            Text('BirthDay: ${patient.birthDay}'),
            Text('Gender: ${patient.gender}'),
            Text('Phone Number: ${patient.phoneNumber}'),
            Text('Email: ${patient.email}'),
          ],
        ),
      ),
    );
  }
}
