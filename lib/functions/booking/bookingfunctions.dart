import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senior/utils/popups.dart';

Future<List<Map<String, dynamic>>> getDentists(BuildContext context) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> dentists = [];

  try {
    QuerySnapshot userSnapshot = await firestore
        .collection('users')
        .where('role', isEqualTo: 'dentist')
        .get();

    for (QueryDocumentSnapshot doc in userSnapshot.docs) {
      if (doc.exists &&
          doc.data() != null &&
          (doc.data() as Map<String, dynamic>).containsKey('name')) {
        String fullName = (doc.data() as Map<String, dynamic>)['name'];
        if (fullName.isNotEmpty) {
          List<String> nameParts = fullName.split(' ');
          String Name;
          if (nameParts.length >= 3) {
            Name = '${nameParts[0]} ${nameParts[1]}';
          } else {
            Name = fullName;
          }
          dentists.add({'id': doc.id, 'Name': Name});
        }
      }
    }
  } catch (e) {
    showErrorDialog(context, "Error: $e");
  }
  return dentists;
}

Future<bool> checkAvailability(
    String selectedDentistId, DateTime date, int hour) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final QuerySnapshot snapshot = await _firestore
      .collection('appointments')
      .where('did', isEqualTo: selectedDentistId)
      .where('date', isEqualTo: date)
      .where('hour', isEqualTo: hour)
      .get();

  return snapshot.docs.isEmpty;
}

Future<List<List<int>>> getAvailableTimeSlots(
    String selectedDentistId, DateTime selectedDate) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  DateTime startDate =
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
  DateTime now = DateTime.now();

  final QuerySnapshot snapshot = await firestore
      .collection('appointments')
      .where('did', isEqualTo: selectedDentistId)
      .where('date', isEqualTo: startDate)
      .get();

  List<int> bookedSlots =
      snapshot.docs.map((doc) => doc['hour'] as int).toList();
  List<int> allSlots = List.generate(9, (index) => index + 9);
  List<int> availableSlots =
      allSlots.where((slot) => !bookedSlots.contains(slot)).toList();

  availableSlots = availableSlots
      .where((slot) => now.isBefore(startDate.add(Duration(hours: slot))))
      .toList();

  List<List<int>> rows = [];
  int slotIndex = 0;
  while (slotIndex < availableSlots.length) {
    List<int> row = [];
    for (int j = 0; j < 3 && slotIndex < availableSlots.length; j++) {
      row.add(availableSlots[slotIndex]);
      slotIndex++;
    }
    rows.add(row);
  }

  return rows;
}

Future<List<List<DateTime>>> getAvailableDates(String selectedDentistId) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<List<DateTime>> availableDatesRows = [];

  List<DateTime> weekDates = [];
  DateTime now = DateTime.now();
  for (int i = 0; i < 7; i++) {
    DateTime date = now.add(Duration(days: i));
    if (date.weekday != DateTime.friday) {
      weekDates.add(date);
    }
  }

  for (DateTime date in weekDates) {
    bool allTimesPassed = await checkAllTimesPassed(selectedDentistId, date);
    if (!allTimesPassed) {
      QuerySnapshot snapshot = await firestore
          .collection('appointments')
          .where('did', isEqualTo: selectedDentistId)
          .where('date', isEqualTo: date)
          .get();

      if (snapshot.docs.length < 9) {
        availableDatesRows.add([date]);
      }
    }
  }

  List<List<DateTime>> rows = [];
  int dateIndex = 0;
  while (dateIndex < availableDatesRows.length) {
    List<DateTime> row = [];
    for (int j = 0; j < 3 && dateIndex < availableDatesRows.length; j++) {
      row.add(availableDatesRows[dateIndex][0]);
      dateIndex++;
    }
    rows.add(row);
  }

  return rows;
}

Future<bool> checkAllTimesPassed(
    String selectedDentistId, DateTime selectedDate) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  DateTime startDate =
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
  DateTime now = DateTime.now();

  final QuerySnapshot snapshot = await firestore
      .collection('appointments')
      .where('did', isEqualTo: selectedDentistId)
      .where('date', isEqualTo: startDate)
      .get();

  List<int> bookedSlots =
      snapshot.docs.map((doc) => doc['hour'] as int).toList();
  List<int> allSlots = List.generate(9, (index) => index + 9);
  List<int> availableSlots =
      allSlots.where((slot) => !bookedSlots.contains(slot)).toList();

  return availableSlots
      .every((slot) => now.isAfter(startDate.add(Duration(hours: slot))));
}

Future<void> addAppointment(BuildContext context, String selectedDentistId,
    DateTime selectedDate, int selectedHour, String userId) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  DateTime dateOnly = DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
  );

  DateTime weekBefore = dateOnly.subtract(Duration(days: 7));
  DateTime weekAfter = dateOnly.add(Duration(days: 7));

  var existingPatientAppointments = await firestore
      .collection('appointments')
      .where('uid', isEqualTo: userId)
      .where('date', isGreaterThanOrEqualTo: weekBefore)
      .where('date', isLessThanOrEqualTo: weekAfter)
      .get();

  if (existingPatientAppointments.docs.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You already have an appointment within a week.'),
      ),
    );
    return;
  }

  var existingAppointment = await firestore
      .collection('appointments')
      .where('did', isEqualTo: selectedDentistId)
      .where('date', isEqualTo: dateOnly)
      .where('hour', isEqualTo: selectedHour)
      .get();

  if (existingAppointment.docs.isEmpty) {
    await firestore.collection('appointments').add({
      'uid': userId,
      'did': selectedDentistId,
      'date': dateOnly,
      'time': selectedHour,
    });
    Navigator.pushReplacementNamed(context, '/patientDashboard');
    showMessagealert(context, 'Appointment booked successfully.');
  } else {
    showErrorDialog(context, 'The selected time is no longer available.');
  }
}
