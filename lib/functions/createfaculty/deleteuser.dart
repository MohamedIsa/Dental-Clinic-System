import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../utils/popups.dart';

Future<void> deleteUser(
    BuildContext context, String userId, String role) async {
  try {
    await FirebaseFirestore.instance.collection('user').doc(userId).delete();

    if (role.toLowerCase() == 'dentist') {
      QuerySnapshot appointmentsSnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('did', isEqualTo: userId)
          .get();

      List<QueryDocumentSnapshot> appointments = appointmentsSnapshot.docs;

      for (var appointment in appointments) {
        DateTime appointmentDate = appointment['date'].toDate();
        int appointmentHour = appointment['hour'];
        int appointmentEnd = appointment['end'];

        QuerySnapshot availableDentistsSnapshot =
            await FirebaseFirestore.instance.collection('dentist').get();

        List<QueryDocumentSnapshot> availableDentists =
            availableDentistsSnapshot.docs;

        String newDentistId = '';
        bool foundAvailableDentist = false;

        for (var dentist in availableDentists) {
          String potentialDentistId = dentist.id;

          QuerySnapshot overlappingAppointmentsSnapshot =
              await FirebaseFirestore.instance
                  .collection('appointments')
                  .where('did', isEqualTo: potentialDentistId)
                  .where('date', isEqualTo: appointmentDate)
                  .get();

          List<QueryDocumentSnapshot> overlappingAppointments =
              overlappingAppointmentsSnapshot.docs;

          bool hasOverlap = overlappingAppointments.any((doc) {
            int start = doc['hour'];
            int end = doc['end'];

            return (appointmentHour < end && appointmentEnd > start);
          });

          if (!hasOverlap) {
            newDentistId = potentialDentistId;
            foundAvailableDentist = true;
            break;
          }
        }

        if (foundAvailableDentist) {
          await FirebaseFirestore.instance
              .collection('appointments')
              .doc(appointment.id)
              .update({'did': newDentistId});
        } else {
          throw Exception(
              'No available dentist found for appointment on ${appointmentDate}');
        }
      }

      await FirebaseFirestore.instance
          .collection('dentist')
          .doc(userId)
          .delete();
    } else if (role.toLowerCase() == 'admin') {
      await FirebaseFirestore.instance.collection('admin').doc(userId).delete();
    } else if (role.toLowerCase() == 'receptionist') {
      await FirebaseFirestore.instance
          .collection('receptionist')
          .doc(userId)
          .delete();
    }

    showMessagealert(context, 'User Deleted Successfully');
  } catch (e) {
    print('Error deleting user: $e');

    showMessagealert(context, 'Error deleting user: $e');
  }
}
