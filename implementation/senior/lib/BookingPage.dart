
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:senior/app_colors.dart';
import 'package:senior/dashboard.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

Future<bool> checkAvailability(String dentist, DateTime date, int hour) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final QuerySnapshot snapshot = await _firestore
      .collection('appointments')
      .where('dentist', isEqualTo: dentist)
      .where('date', isEqualTo: date)
      .where('hour', isEqualTo: hour)
      .get();

  return snapshot.docs.isEmpty;
}

Future<List<int>> getAvailableTimeSlots(
    String selectedDentist, DateTime selectedDate) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final QuerySnapshot snapshot = await firestore
      .collection('appointments')
      .where('dentist', isEqualTo: selectedDentist)
      .where('date', isEqualTo: selectedDate)
      .get();

  List<int> bookedSlots =
      snapshot.docs.map((doc) => doc['hour'] as int).toList();
  List<int> allSlots = List.generate(
      9, (index) => index + 9); // Generate all time slots from 9:00 to 17:00
  List<int> availableSlots =
      allSlots.where((slot) => !bookedSlots.contains(slot)).toList();
  return availableSlots;
}

class _BookingPageState extends State<BookingPage> {
  String selectedDentist = 'Dentist 1';
  DateTime selectedDate = DateTime.now();
  int selectedHour = 9;

  bool showDate = false;
  bool showTime = false;
  bool showcontainer = false;

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: Colors.grey[150],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: AppColors.bccolor,
          padding: const EdgeInsets.only(left: 50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Container(
                    width: 430,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                            'Please select a dentist from the list below.'),
                        Row(
                          children: [
                            for (var dentist in [
                              'Dentist 1',
                              'Dentist 2',
                              'Dentist 3'
                            ])
                              Container(
                                width: 120,
                                height: 40,
                                margin: const EdgeInsets.all(5),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedDentist = dentist;
                                      showDate = true;
                                    });
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      dentist,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var dentist in ['Dentist 4', 'Dentist 5'])
                              Container(
                                width: 120,
                                height: 40,
                                margin: const EdgeInsets.all(5),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedDentist = dentist;
                                      showDate = true;
                                    });
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      dentist,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (showDate)
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Row(
                      children: [
                        Container(
                          width: 430,
                          height: 170,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                  'Please select a date from the calendar below.'),
                              if (showDate || showcontainer)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (var i = 0; i < 4; i++)
                                      if (DateTime.now()
                                                  .add(Duration(days: i))
                                                  .weekday !=
                                              DateTime.friday ||
                                          i == 2)
                                        Container(
                                          width: 120,
                                          height: 40,
                                          margin: const EdgeInsets.all(5),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                selectedDate = DateTime.now()
                                                    .add(Duration(days: i));
                                                showTime = true;
                                              });
                                            },
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              DateFormat('MM/dd').format(
                                                  DateTime.now()
                                                      .add(Duration(days: i))),
                                            ),
                                          ),
                                        ),
                                  ],
                                ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (var i = 4; i < 7; i++)
                                    if (DateTime.now()
                                                .add(Duration(days: i))
                                                .weekday !=
                                            DateTime.friday ||
                                        i == 5)
                                      Container(
                                        width: 120,
                                        height: 40,
                                        margin: const EdgeInsets.all(5),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              selectedDate = DateTime.now()
                                                  .add(Duration(days: i));
                                              showTime = true;
                                            });
                                          },
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            DateFormat('MM/dd').format(
                                                DateTime.now()
                                                    .add(Duration(days: i))),
                                          ),
                                        ),
                                      ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 200),
                        Visibility(
                          visible: showcontainer && showTime,
                          child: SizedBox(
                            width: 400,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: AppColors.bccolor, width: 2),
                                color: Colors.blue,
                              ),
                              width: 140,
                              height: 170,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Your Appointment Details',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Selected Dentist: $selectedDentist\nSelected Date: ${DateFormat('MM/dd').format(selectedDate)}\nSelected Time: $selectedHour:00\n',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      FirebaseAuth _auth =
                                          FirebaseAuth.instance;
                                      User? user = _auth.currentUser;
                                      if (user != null) {
                                        // Create a new DateTime object with only year, month, and day
                                        DateTime dateOnly = DateTime(
                                            selectedDate.year,
                                            selectedDate.month,
                                            selectedDate.day);

                                        // Check if an appointment already exists at the selected time
                                        var existingAppointment =
                                            await firestore
                                                .collection('appointments')
                                                .where('dentist',
                                                    isEqualTo: selectedDentist)
                                                .where('date',
                                                    isEqualTo: dateOnly)
                                                .where('hour',
                                                    isEqualTo: selectedHour)
                                                .get();

                                        if (existingAppointment.docs.isEmpty) {
                                          // If no existing appointment, book the appointment
                                          await firestore
                                              .collection('appointments')
                                              .add({
                                            'uid': user.uid,
                                            'dentist': selectedDentist,
                                            'date': dateOnly,
                                            'hour': selectedHour,
                                          });
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      WelcomePage()));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Appointment booked successfully!'),
                                            ),
                                          );
                                        } else {
                                          // If an appointment already exists, show an error message
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'This time slot is already booked. Please select a different time.'),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: Text('Book Appointment'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                if (showTime) // Only show time slots if showTime is true
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Container(
                      width: 430,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                              'Please select a time from the list below.'),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<List<int>>(
                                future: getAvailableTimeSlots(
                                    selectedDentist, selectedDate),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator(); // Show loading indicator while fetching data
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    List<int> availableSlots =
                                        snapshot.data ?? [];

                                    if (availableSlots.isEmpty) {
                                      return Text(
                                          'No available time slots for selected date.'); // Display message when no time slots are available
                                    } else {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          for (var startHour = 0;
                                              startHour < 9;
                                              startHour += 3)
                                            Row(
                                              children: [
                                                for (var i = startHour;
                                                    i < startHour + 3;
                                                    i++)
                                                  if (i < 9 &&
                                                      availableSlots
                                                          .contains(i + 9))
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: Container(
                                                          width: 120,
                                                          height: 40,
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                selectedHour =
                                                                    i + 9;
                                                                showcontainer =
                                                                    true;
                                                              });
                                                            },
                                                            style: ButtonStyle(
                                                              shape: MaterialStateProperty
                                                                  .all<
                                                                      RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                              ),
                                                            ),
                                                            child: Text(
                                                                '${i + 9}:00'),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                              ],
                                            ),
                                        ],
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
