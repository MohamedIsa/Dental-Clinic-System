import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../models/appointments.dart';
import 'package:logger/logger.dart';

Future<String> getUpcomingAppointment(String patientId) async {
  final DateTime now = DateTime.now();
  final Logger logger = Logger();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    final QuerySnapshot snapshot = await firestore
        .collection('users')
        .doc(patientId)
        .collection('appointments')
        .get();

    logger.i('Number of appointments fetched: ${snapshot.docs.length}');

    if (snapshot.docs.isEmpty) {
      return 'No upcoming appointments';
    }

    String? upcomingAppointment;
    DateTime? earliestDateTime;

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      logger.d('Raw appointment data: ${doc.data()}');

      final Appointments appointment = Appointments.fromFirestore(
          doc.id, doc.data() as Map<String, dynamic>);
      logger.d(
          'Parsed Appointment: Date - ${appointment.date}, Time - ${appointment.time}');

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

        logger.d('Parsed DateTime: $appointmentDateTime');
        logger.d('Current DateTime: $now');

        if (appointmentDateTime.isAfter(now)) {
          logger.i('Upcoming appointment found: $appointmentDateTime');

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
      } catch (e) {
        logger.e(
            'Error parsing appointment: ${appointment.date}, ${appointment.time} - $e');
      }
    }

    if (upcomingAppointment != null) {
      return upcomingAppointment;
    } else {
      return 'No upcoming appointments';
    }
  } catch (e) {
    logger.e('Error: $e');
    return 'Error retrieving appointments';
  }
}
