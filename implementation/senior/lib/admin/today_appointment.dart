import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class TodayAppointmentPage extends StatelessWidget {
  const TodayAppointmentPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: 300, // Set a fixed height for the calendar
          child: StreamBuilder<QuerySnapshot>(
            // StreamBuilder to listen for changes in Firestore collection
            stream: FirebaseFirestore.instance.collection('appointments').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<Appointment> appointments = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final DateTime date = data['date'].toDate();
                  final int hour = data['hour'];
                  final DateTime startTime = DateTime(date.year, date.month, date.day, hour);
                  final DateTime endTime = startTime.add(Duration(hours: 1)); // Duration is 1 hour
                  
                  // Fetch dentist's name
                  final String dentistId = data['did'];
                  String dentistName = 'Unknown Dentist';
                  FirebaseFirestore.instance.collection('dentist').doc(dentistId).get().then((dentistDoc) {
                    if (dentistDoc.exists) {
                      dentistName = dentistDoc.data()?['FullName'] ?? 'Unknown Dentist';
                    } else {
                      // If did doesn't exist in dentist collection, fetch from user collection
                      FirebaseFirestore.instance.collection('user').doc(dentistId).get().then((userDoc) {
                        if (userDoc.exists) {
                          dentistName = userDoc.data()?['FullName'] ?? 'Unknown Dentist';
                        }
                      });
                    }
                  });

                  // Fetch patient's name
                  final String patientId = data['uid'];
                  String patientName = 'Unknown Patient';
                  FirebaseFirestore.instance.collection('patient').doc(patientId).get().then((patientDoc) {
                    if (patientDoc.exists) {
                      patientName = patientDoc.data()?['FullName'] ?? 'Unknown Patient';
                    }
                  });

                  return Appointment(
                    startTime: startTime,
                    endTime: endTime,
                    subject: 'Appointment with $patientName, Dentist: $dentistName',
                    color: Colors.blue, // You can set colors based on different appointments
                  );
                }).toList();
                return SfCalendar(
                  view: CalendarView.timelineDay,
                  timeSlotViewSettings: const TimeSlotViewSettings(
                    startHour: 9,
                    endHour: 18,
                    timeIntervalWidth: 100, 
                  ),
                  dataSource: AppointmentDataSource(appointments),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
