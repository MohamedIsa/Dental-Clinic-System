import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodayAppointmentPage extends StatelessWidget {
  const TodayAppointmentPage({super.key});

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
                'Today Appointments',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 400,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('appointments')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No appointments available'));
                    }
                    return FutureBuilder<List<Appointment>>(
                      future: _fetchAppointments(snapshot.data!.docs),
                      builder: (context, appointmentSnapshot) {
                        if (appointmentSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (appointmentSnapshot.hasError) {
                          return Center(
                              child:
                                  Text('Error: ${appointmentSnapshot.error}'));
                        }
                        return SfCalendar(
                          view: CalendarView.timelineDay,
                          timeSlotViewSettings: TimeSlotViewSettings(
                            startHour: 9,
                            endHour: 18,
                            timeIntervalWidth: 100,
                          ),
                          dataSource:
                              AppointmentDataSource(appointmentSnapshot.data!),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Appointment>> _fetchAppointments(
      List<DocumentSnapshot> documents) async {
    final List<Appointment> appointments = [];

    for (final doc in documents) {
      final data = doc.data() as Map<String, dynamic>;
      final DateTime date = data['date'].toDate();
      final int hour = data['hour'];
      final DateTime startTime =
          DateTime(date.year, date.month, date.day, hour);
      DateTime endTime;

      if (data['end'] != null) {
        endTime = DateTime(date.year, date.month, date.day, data['end']);
      } else {
        endTime = startTime.add(Duration(minutes: 30));
      }

      final String patientId = data['uid'];
      final String dentistId = data['did'];
      QuerySnapshot dentistDoc = await FirebaseFirestore.instance
          .collection('dentist')
          .where('uid', isEqualTo: dentistId)
          .get();
      String dentistColor =
          (dentistDoc.docs[0].data() as Map<String, dynamic>)['color'];
      String hexColor = decimalToHex(int.parse(dentistColor));
      final String patientName = await getPatientName(patientId);

      appointments.add(Appointment(
        startTime: startTime,
        endTime: endTime,
        subject: 'Appointment with $patientName',
        color: Color(int.parse(hexColor)),
      ));
    }
    return appointments;
  }

  Future<String> getPatientName(String patientId) async {
    String patientName = 'Unknown Patient';
    final patientDoc = await FirebaseFirestore.instance
        .collection('user')
        .doc(patientId)
        .get();
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

String decimalToHex(int decimalColor) {
  return '0x${decimalColor.toRadixString(16).toUpperCase()}';
}
