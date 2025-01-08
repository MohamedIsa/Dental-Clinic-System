import 'package:flutter/material.dart';
import 'package:senior/models/users.dart';

import '../../../chat/chatpage.dart';

class PatientDetailsPage extends StatelessWidget {
  final Users patient;

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
            Text('Name: ${patient.name}'),
            Text('CPR: ${patient.cpr}'),
            Text('BirthDay: ${patient.dob}'),
            Text('Gender: ${patient.gender}'),
            Text('Phone Number: ${patient.phone}'),
            Text('Email: ${patient.email}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ChatPage(patientId: patient.id);
          }));
        },
        child: Icon(Icons.chat),
      ),
    );
  }
}
