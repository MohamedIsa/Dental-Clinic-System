import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class TodayAppointmentPage extends StatelessWidget {
  const TodayAppointmentPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Today Appointment',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                // StreamBuilder to listen for changes in Firestore collection
                stream: FirebaseFirestore.instance.collection('appointments').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<Appointment> todayAppointments = [];
                    final now = DateTime.now();
                    
                    for (final doc in snapshot.data!.docs) {
                      final data = doc.data() as Map<String, dynamic>;
                      final DateTime date = data['date'].toDate();
                      
                      if (date.year == now.year && date.month == now.month && date.day == now.day) {
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

                        todayAppointments.add(Appointment(
                          startTime: startTime,
                          endTime: endTime,
                          subject: 'Appointment with $patientName, Dentist: $dentistName',
                          color: Colors.blue, // You can set colors based on different appointments
                        ));
                      }
                    }
                    
                    return SfCalendar(
                      view: CalendarView.timelineDay,
                      timeSlotViewSettings: const TimeSlotViewSettings(
                        startHour: 9,
                        endHour: 18,
                        timeIntervalWidth: 100,
                      ),
                      dataSource: AppointmentDataSource(todayAppointments),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
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
