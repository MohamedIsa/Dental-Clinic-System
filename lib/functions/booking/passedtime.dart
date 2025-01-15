import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:senior/functions/booking/checkavailability.dart';
import 'package:senior/utils/popups.dart';

Future<bool> checkAllTimesPassed(
    BuildContext context, String dentistId, DateTime date) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String dateStr = DateFormat('yyyy-MM-dd').format(date);

  try {
    final QuerySnapshot snapshot = await firestore
        .collection('users')
        .doc(dentistId)
        .collection('appointments')
        .where('date', isEqualTo: dateStr)
        .get();

    DateTime now = DateTime.now();
    List<int> bookedSlots = snapshot.docs
        .map((doc) => (doc.data() as Map<String, dynamic>)['time'] as int)
        .toList();
    List<int> allSlots = generateTimeSlots();

    List<int> remainingSlots =
        allSlots.where((slot) => !bookedSlots.contains(slot)).toList();

    return remainingSlots.every(
        (slot) => now.isAfter(DateTime(date.year, date.month, date.day, slot)));
  } catch (e) {
    showErrorDialog(context, 'Error: $e');
    return false;
  }
}
