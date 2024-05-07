import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:senior/app_colors.dart';
import 'package:senior/responsive_widget.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  _BookingPageState createState() => _BookingPageState();
}

Future<List<Map<String, dynamic>>> getDentists() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> dentists = [];

  try {
    QuerySnapshot dentistSnapshot = await firestore.collection('dentist').get();

    for (QueryDocumentSnapshot doc in dentistSnapshot.docs) {
      String dentistId = doc.id;

      DocumentSnapshot userSnapshot =
          await firestore.collection('user').doc(dentistId).get();

      if (userSnapshot.exists &&
          userSnapshot.data() != null &&
          (userSnapshot.data() as Map<String, dynamic>)
              .containsKey('FullName')) {
        String fullName =
            (userSnapshot.data() as Map<String, dynamic>)['FullName'];
        if (fullName.isNotEmpty) {
          List<String> nameParts = fullName.split(' ');
          String Name;
          if (nameParts.length >= 3) {
            // If there are 3 or more parts, take only the first two
            Name = '${nameParts[0]} ${nameParts[1]}';
          } else {
            // If there are less than 3 parts, keep the full name
            Name = fullName;
          }
          dentists.add({'id': dentistId, 'Name': Name});
        }
      }
    }
  } catch (e) {
    print('Error fetching dentists: $e');
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

  // Create a DateTime object with only year, month, and day to match the date field in the database
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
  List<int> allSlots = List.generate(
      9, (index) => index + 9); // Generate all time slots from 9:00 to 17:00
  List<int> availableSlots =
      allSlots.where((slot) => !bookedSlots.contains(slot)).toList();

  // Filter out time slots that have already passed
  availableSlots = availableSlots
      .where((slot) => now.isBefore(startDate.add(Duration(hours: slot))))
      .toList();

  // Create rows with exactly three time slots each
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

  // Create a list of dates for one week excluding Fridays
  List<DateTime> weekDates = [];
  DateTime now = DateTime.now();
  for (int i = 0; i < 7; i++) {
    DateTime date = now.add(Duration(days: i));
    if (date.weekday != DateTime.friday) {
      weekDates.add(date);
    }
  }

  // Filter out dates with less than 9 appointments for the selected dentist
  for (DateTime date in weekDates) {
    // Check if all available times have passed without being booked
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

  // Create rows with exactly three dates each
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

  // Create a DateTime object with only year, month, and day to match the date field in the database
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
  List<int> allSlots = List.generate(
      9, (index) => index + 9); // Generate all time slots from 9:00 to 17:00
  List<int> availableSlots =
      allSlots.where((slot) => !bookedSlots.contains(slot)).toList();

  // Check if all available time slots have passed
  return availableSlots
      .every((slot) => now.isAfter(startDate.add(Duration(hours: slot))));
}

class _BookingPageState extends State<BookingPage> {
  @override
  void initState() {
    super.initState();
    getDentists().then((dentists) {
      setState(() {
        dentistFirstNames =
            dentists.map((dentist) => dentist['Name'] as String).toList();
      });
    });
  }

  DateTime selectedDate = DateTime.now();
  int selectedHour = 9;
  List<String> dentistFirstNames = [];
  String selectedDentistId = '';
  String selectedDentistFirstName = '';

  bool showDate = false;
  bool showTime = false;
  bool showcontainer = false;
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book Appointment',
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.grey[150],
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (ResponsiveWidget.isMediumScreen(context) ||
                ResponsiveWidget.isLargeScreen(context))
              Container(
                color: Colors.blue,
                height: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/dashboard');
                          },
                          child: const Text(
                            'Home',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Book Appointment',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/appointmenthistory');
                          },
                          child: const Text(
                            'Appointment History',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/update');
                          },
                          child: const Text(
                            'Update Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Edit Appointment',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.only(left: 50, top: 30),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Row(
                        children: [
                          Container(
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
                                  'Please select a dentist from the list below.',
                                  style: TextStyle(color: Colors.white),
                                ),
                                FutureBuilder<List<Map<String, dynamic>>>(
                                  future: getDentists(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: SpinKitFadingCube(
                                          color: Colors.white,
                                          size: 20.0,
                                        ),
                                      ); // Show loading indicator while fetching data
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      List<Map<String, dynamic>> dentists =
                                          snapshot.data ?? [];
                                      return Column(
                                        children: [
                                          for (int i = 0;
                                              i < dentists.length;
                                              i += 3)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                for (int j = i;
                                                    j < i + 3 &&
                                                        j < dentists.length;
                                                    j++)
                                                  Container(
                                                    width: 120,
                                                    height: 40,
                                                    margin:
                                                        const EdgeInsets.all(5),
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          selectedDentistId =
                                                              dentists[j]['id'];
                                                          selectedDentistFirstName =
                                                              dentists[j]
                                                                  ['Name'];
                                                          showDate = true;
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
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 8.0),
                                                        child: Text(
                                                          'Dr. ${dentists[j]['Name']}',
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 200),
                          if (showTime)
                            Container(
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
                                    'Please select a time from the list below.',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FutureBuilder<List<List<int>>>(
                                        future: getAvailableTimeSlots(
                                            selectedDentistId, selectedDate),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: SpinKitFadingCube(
                                                color: Colors.white,
                                                size: 20.0,
                                              ),
                                            ); // Show loading indicator while fetching data
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else {
                                            List<List<int>> availableSlotsRows =
                                                snapshot.data ?? [];

                                            if (availableSlotsRows.isEmpty) {
                                              return const Text(
                                                'No available time slots for selected date.',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0,
                                                ),
                                              ); // Display message when no time slots are available
                                            } else {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  for (var slotsRow
                                                      in availableSlotsRows)
                                                    Row(
                                                      children: [
                                                        for (var slot
                                                            in slotsRow)
                                                          Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8),
                                                              child: SizedBox(
                                                                width: 120,
                                                                height: 40,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    bool
                                                                        appointmentAvailable =
                                                                        await checkAvailability(
                                                                      selectedDentistId,
                                                                      selectedDate,
                                                                      slot,
                                                                    );
                                                                    if (appointmentAvailable) {
                                                                      setState(
                                                                          () {
                                                                        selectedHour =
                                                                            slot;
                                                                        showcontainer =
                                                                            true;
                                                                      });
                                                                    }
                                                                  },
                                                                  style:
                                                                      ButtonStyle(
                                                                    shape: WidgetStateProperty
                                                                        .all<
                                                                            RoundedRectangleBorder>(
                                                                      RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                      '$slot:00'),
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
                        ],
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Please select a date from the list below.',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FutureBuilder<List<List<DateTime>>>(
      future: getAvailableDates(selectedDentistId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(top: 50),
            child: SpinKitFadingCube(
              color: Colors.white,
              size: 20.0,
            ),
          ); // Show loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<List<DateTime>> availableDatesRows = snapshot.data ?? [];

          if (availableDatesRows.isEmpty) {
            return const Text(
              'No available dates for selected dentist.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ); // Display message when no dates are available
          } else {
            List<Widget> dateRows = [];
            for (var datesRow in availableDatesRows) {
              List<Widget> buttonsInRow = [];
              for (var date in datesRow) {
                buttonsInRow.add(
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 120,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDate = date;
                            showTime = true;
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
                        child: Text(
                          DateFormat('MM/dd').format(date),
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
                );
              }
              dateRows.add(Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: buttonsInRow,
              ));
            }
            return Column(
              children: dateRows,
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
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        'Your Appointment Details',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Selected Dentist: Dr.$selectedDentistFirstName\nSelected Date: ${DateFormat('MM/dd').format(selectedDate)}\nSelected Time: $selectedHour:00\n',
                                        style: const TextStyle(
                                            color: Colors.white),
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
                                              selectedDate.day,
                                            );

                                            // Check if an appointment already exists at the selected time
                                            var existingAppointment =
                                                await firestore
                                                    .collection('appointments')
                                                    .where('did',
                                                        isEqualTo:
                                                            selectedDentistId)
                                                    .where('date',
                                                        isEqualTo: dateOnly)
                                                    .where('hour',
                                                        isEqualTo: selectedHour)
                                                    .get();

                                            if (existingAppointment
                                                .docs.isEmpty) {
                                              // If no existing appointment, book the appointment
                                              await firestore
                                                  .collection('appointments')
                                                  .add({
                                                'uid': user.uid,
                                                'did': selectedDentistId,
                                                'date': dateOnly,
                                                'hour': selectedHour,
                                              });
                                              Navigator.pushNamed(
                                                  context, '/dashboard');
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Appointment booked successfully!'),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        child: const Text('Book Appointment'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
