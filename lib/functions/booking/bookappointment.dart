import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../models/appointments.dart';
import '../../utils/popups.dart';

Future<void> bookAppointment(BuildContext context, bool isFacility,
    String dentistId, DateTime date, int hour, String patientId) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String dateStr = DateFormat('yyyy-MM-dd').format(date);
  DateTime weekBefore = DateTime(date.year, date.month, date.day - 7);
  DateTime weekAfter = DateTime(date.year, date.month, date.day + 7);

  try {
    final QuerySnapshot existingPatientAppointments = await firestore
        .collection('users')
        .doc(patientId)
        .collection('appointments')
        .where('date', isGreaterThanOrEqualTo: weekBefore.toIso8601String())
        .where('date', isLessThanOrEqualTo: weekAfter.toIso8601String())
        .get();

    if (existingPatientAppointments.docs.isNotEmpty) {
      showErrorDialog(context, 'You already have an appointment this week.');
      return;
    }

    final QuerySnapshot existingAppointment = await firestore
        .collection('users')
        .doc(dentistId)
        .collection('appointments')
        .where('date', isEqualTo: dateStr)
        .where('time', isEqualTo: hour)
        .get();

    if (existingAppointment.docs.isEmpty) {
      final batch = firestore.batch();

      final String appointmentId =
          firestore.collection('appointments').doc().id;

      final mainAppointmentRef =
          firestore.collection('appointments').doc(appointmentId);
      final appointmentData = Appointments(
        id: appointmentId,
        patientId: patientId,
        dentistId: dentistId,
        date: dateStr,
        time: hour,
      ).toFirestore();

      batch.set(mainAppointmentRef, appointmentData);

      final dentistAppointmentRef = firestore
          .collection('users')
          .doc(dentistId)
          .collection('appointments')
          .doc(appointmentId);
      batch.set(dentistAppointmentRef, appointmentData);

      final patientAppointmentRef = firestore
          .collection('users')
          .doc(patientId)
          .collection('appointments')
          .doc(appointmentId);
      batch.set(patientAppointmentRef, appointmentData);

      await batch.commit();

      isFacility ? context.go('/dashboard') : context.go('/patientDashboard');
      showMessagealert(context, 'Appointment booked successfully.');
    } else {
      showErrorDialog(context, 'This time slot is already booked.');
    }
  } catch (e) {
    showErrorDialog(context, "Error: $e");
  }
}
