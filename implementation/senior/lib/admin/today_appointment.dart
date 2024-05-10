import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                stream: FirebaseFirestore.instance.collection('appointments').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.hasData) {
                    return FutureBuilder<List<Appointment>>(
                      future: _fetchAppointments(snapshot.data!.docs),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        final List<Appointment> todayAppointments = snapshot.data!;
                        return SfCalendar(
                          view: CalendarView.timelineDay,
                          timeSlotViewSettings: const TimeSlotViewSettings(
                            startHour: 9,
                            endHour: 18,
                            timeIntervalWidth: 100,
                          ),
                          dataSource: AppointmentDataSource(todayAppointments),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('No data available'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Appointment>> _fetchAppointments(List<DocumentSnapshot> documents) async {
    final List<Appointment> todayAppointments = [];
    final now = DateTime.now();

    for (final doc in documents) {
      final data = doc.data() as Map<String, dynamic>;
      final DateTime date = data['date'].toDate();

      if (date.year == now.year && date.month == now.month && date.day == now.day) {
        final int hour = data['hour'];
        final DateTime startTime = DateTime(date.year, date.month, date.day, hour);
        final DateTime endTime = startTime.add(Duration(hours: 1));

        final String patientId = data['uid'];
        final String patientName = await getPatientName(patientId);
        

        final colorSnapshot = await FirebaseFirestore.instance.collection('color').doc(patientId).get();
        final String? color = colorSnapshot.data()?['color'];

        todayAppointments.add(Appointment(
          startTime: startTime,
          endTime: endTime,
          subject: 'Appointment with $patientName',
          color: color != null ? Color(int.parse(color)) : Colors.blue,
        ));
      }
    }

    return todayAppointments;
  }

  Future<String> getPatientName(String patientId) async {
    String patientName = 'Unknown Patient';
    final patientDoc = await FirebaseFirestore.instance.collection('user').doc(patientId).get();
    if (patientDoc.exists) {
      final fullName = patientDoc.data()?['FullName'] ?? 'Unknown Patient';
      final List<String> names = fullName.split(' ');
      if (names.length >= 2) {
        patientName = '${names[0]} ${names[1]}';
      } else {
        patientName = fullName;
      }
    }
    return patientName;
  }
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
