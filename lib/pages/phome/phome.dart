import 'package:flutter/material.dart';

class PatientHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to the Dental Clinic System',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to appointment booking page
              },
              child: Text('Book an Appointment'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to view medical records page
              },
              child: Text('View Medical Records'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to contact us page
              },
              child: Text('Contact Us'),
            ),
          ],
        ),
      ),
    );
  }
}
