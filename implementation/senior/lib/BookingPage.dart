import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
String selectedDentist = 'Dentist 1';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> bookAppointment() async {
    // Format the date and time
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    String formattedTime = selectedTime.format(context);

    // Store booking information in Firestore
    await FirebaseFirestore.instance.collection('appointments').add({
      'dentist': selectedDentist,
      'date': formattedDate,
      'time': formattedTime,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });

    // Navigate back to dashboard
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: selectedDentist,
              onChanged: (newValue) {
                setState(() {
                  selectedDentist = newValue!;
                });
              },
              items: [
                DropdownMenuItem(
                  child: Text('Dentist 1'),
                  value: 'Dentist 1',
                ),
                DropdownMenuItem(
                  child: Text('Dentist 2'),
                  value: 'Dentist 2',
                ),
                // Add more dentists here
              ],
              hint: Text('Select Dentist'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null && pickedDate != selectedDate)
                  setState(() {
                    selectedDate = pickedDate;
                  });
              },
              child: Text('Select Date'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (pickedTime != null && pickedTime != selectedTime)
                  setState(() {
                    selectedTime = pickedTime;
                  });
              },
              child: Text('Select Time'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedDentist.isNotEmpty) {
                  bookAppointment();
                } else {
                  // Show error message if dentist is not selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select dentist.'),
                    ),
                  );
                }
              },
              child: Text('Book Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}
