import 'package:flutter/material.dart';
import 'package:senior/models/users.dart';
import 'package:senior/utils/data.dart';

import '../chat/chatpage.dart';

class PatientDetailsPage extends StatelessWidget {
  final Users patient;

  const PatientDetailsPage({super.key, required this.patient});

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Patient Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade500,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100, Colors.white],
            stops: [0.0, 0.8],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, Colors.blue.shade50],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      SizedBox(height: 24),
                      _buildDetailRow('Name', patient.name),
                      _buildDetailRow('CPR', patient.cpr),
                      _buildDetailRow('Date of Birth', patient.dob),
                      _buildDetailRow('Gender', patient.gender),
                      SizedBox(height: 24),
                      Text(
                        'Contact Information',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      SizedBox(height: 24),
                      _buildDetailRow('Phone', patient.phone),
                      _buildDetailRow('Email', patient.email),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FutureBuilder<String>(
        future: Data.currentRole(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return SizedBox.shrink();

          final currentRole = snapshot.data!;
          if (currentRole != 'dentist' && currentRole != 'patient') {
            return FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      patientId: patient.id,
                      senderId: Data.currentID!,
                    ),
                  ),
                );
              },
              backgroundColor: Colors.blue.shade500,
              icon: Icon(Icons.chat, color: Colors.white),
              label: Text(
                'Chat',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
