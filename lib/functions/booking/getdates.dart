import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:senior/utils/popups.dart';

Future<List<DateTime>> getAvailableDates(
    BuildContext context, String dentistId) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DateTime now = DateTime.now();
  List<DateTime> dates = [];

  try {
    for (int i = 0; i < 7; i++) {
      DateTime date = now.add(Duration(days: i));
      if (date.weekday != DateTime.friday) {
        String dateStr = DateFormat('yyyy-MM-dd').format(date);

        final QuerySnapshot snapshot = await firestore
            .collection('users')
            .doc(dentistId)
            .collection('appointments')
            .where('date', isEqualTo: dateStr)
            .get();

        if (snapshot.docs.length < 9) {
          dates.add(date);
        }
      }
    }
  } catch (e) {
    showErrorDialog(context, 'Error: $e');
  }

  return dates;
}
