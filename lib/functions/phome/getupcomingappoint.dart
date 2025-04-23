import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../models/appointments.dart';

Future<String> getUpcomingAppointment(String patientId) async {
  final DateTime now = DateTime.now();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    final QuerySnapshot snapshot = await firestore
        .collection('users')
        .doc(patientId)
        .collection('appointments')
        .get();

    if (snapshot.docs.isEmpty) {
      return 'No upcoming appointments';
    }

    String? upcomingAppointment;
    DateTime? earliestDateTime;

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      final Appointments appointment = Appointments.fromFirestore(
          doc.id, doc.data() as Map<String, dynamic>);

      try {
        final DateTime appointmentDate =
            DateFormat('yyyy-MM-dd').parse(appointment.date);
        final int appointmentTime = (appointment.time as num).toInt();

        final DateTime appointmentDateTime = DateTime(
          appointmentDate.year,
          appointmentDate.month,
          appointmentDate.day,
          appointmentTime,
        );

        if (appointmentDateTime.isAfter(now)) {
          if (earliestDateTime == null ||
              appointmentDateTime.isBefore(earliestDateTime)) {
            earliestDateTime = appointmentDateTime;

            // Fetch dentist's name using dentistId
            final docDentist = await firestore
                .collection('users')
                .doc(appointment.dentistId)
                .get();
            final String dentistName = docDentist.exists
                ? (docDentist.data() != null
                    ? docDentist.data()!['name']
                    : 'Unknown')
                : 'Unknown';
            String formattedTime;
            if (appointmentTime < 12) {
              formattedTime = '$appointmentTime:00 AM';
            } else if (appointmentTime == 12) {
              formattedTime = '$appointmentTime:00 PM';
            } else {
              formattedTime = '${appointmentTime - 12}:00 PM';
            }
            upcomingAppointment =
                'Upcoming Appointment\nDate: ${appointment.date}\nTime: $formattedTime\nDentist: $dentistName';
          }
        }
      } catch (e) {}
    }

    if (upcomingAppointment != null) {
      return upcomingAppointment;
    } else {
      return 'No upcoming appointments';
    }
  } catch (e) {
    return 'Error fetching upcoming appointment';
  }
}
