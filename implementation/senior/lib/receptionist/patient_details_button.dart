import 'package:flutter/material.dart';
import 'package:senior/receptionist/patient_model.dart';
import 'package:senior/chatpage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PatientDetailsPage extends StatelessWidget {
  final PatientData patient;
  final User user;

  const PatientDetailsPage({required this.patient, required this.user});

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                key: Key('chatPage'),
                user: user,
                otherUserId: patient.id, 
                isAdmin: false, 
                isReceptionist: true,
                isPatient: false,
                conversationId: patient.id,
              ),
            ),
          );
        },
        child: Icon(Icons.chat, color: Colors.blue,),
      ),
    );
  }
}
