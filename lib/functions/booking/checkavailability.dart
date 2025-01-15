import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:senior/utils/popups.dart';

Future<bool> checkAvailability(
    BuildContext context, String dentistId, DateTime date, int time) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String dateStr = DateFormat('yyyy-MM-dd').format(date);

  try {
    final QuerySnapshot snapshot = await firestore
        .collection('users')
        .doc(dentistId)
        .collection('appointments')
        .where('date', isEqualTo: dateStr)
        .where('time', isEqualTo: time)
        .get();

    return snapshot.docs.isEmpty;
  } catch (e) {
    showErrorDialog(context, "Error: $e");
    return false;
  }
}

List<int> generateTimeSlots({int startHour = 9, int totalHours = 9}) {
  return List.generate(totalHours, (index) => startHour + index);
}
