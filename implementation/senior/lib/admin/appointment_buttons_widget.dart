import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senior/reuseable_widget.dart';

class AppointmentButtonsWidget extends StatefulWidget {
  final VoidCallback? onCreateAppointmentPressed;
  final VoidCallback? onViewAppointmentsPressed;
  final VoidCallback? onEditAppointmentPressed;
  final VoidCallback? onCancelAppointmentPressed;

  const AppointmentButtonsWidget({
    Key? key,
    this.onCreateAppointmentPressed,
    this.onViewAppointmentsPressed,
    this.onEditAppointmentPressed,
    this.onCancelAppointmentPressed,
  }) : super(key: key);

  @override
  _AppointmentButtonsWidgetState createState() =>
      _AppointmentButtonsWidgetState();
}

class _AppointmentButtonsWidgetState extends State<AppointmentButtonsWidget> {
  DateTime _selectedDate = DateTime.now(); // To store selected appointment date
  TextEditingController _dateController = TextEditingController();
  TextEditingController _cprControllerbook = TextEditingController();
  TextEditingController _cprController = TextEditingController();
  TextEditingController _statController = TextEditingController();
  TextEditingController _endController = TextEditingController();
  List<String> dentistName = [];
  String selectedDentistId = '';
  String selectedDentistName = '';
  int selectedDentistIndex = -1;
  @override
  void initState() {
    super.initState();
    fetchDentists().then((dentists) {
      setState(() {
        dentistName =
            dentists.map((dentist) => dentist['Name'] as String).toList();
      });
    });
  }

  Future<List<Map<String, dynamic>>> fetchDentists() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<Map<String, dynamic>> dentists = [];

    try {
      QuerySnapshot dentistSnapshot =
          await firestore.collection('dentist').get();

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

          dentists.add({'id': dentistId, 'name': fullName});
        }
      }
    } catch (e) {
      print('Error fetching dentists: $e');
    }
    return dentists;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonTheme(
            minWidth: 120,
            child: ElevatedButton(
              onPressed: () => showCreateAppointmentDialog(context),
              child: const Text(
                'Book Appointment',
                style:
                    TextStyle(color: Colors.white), // Set text color to white
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Set background color to blue
              ),
            ),
          ),
          const SizedBox(width: 16),
          ButtonTheme(
            minWidth: 120,
            child: ElevatedButton(
              onPressed: () => showSearchAppointmentDialog(context),
              child: const Text(
                'View Appointment',
                style:
                    TextStyle(color: Colors.white), // Set text color to white
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Set background color to blue
              ),
            ),
          ),
          const SizedBox(width: 16),
          ButtonTheme(
            minWidth: 120,
            child: ElevatedButton(
              onPressed: () => showEditAppointmentDialog(context),
              child: const Text(
                'Edit Appointment',
                style:
                    TextStyle(color: Colors.white), // Set text color to white
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Set background color to blue
              ),
            ),
          ),
          const SizedBox(width: 16),
          ButtonTheme(
            minWidth: 120,
            child: ElevatedButton(
              onPressed: () => showCancelAppointmentDialog(context),
              child: const Text(
                'Cancel Appointment',
                style:
                    TextStyle(color: Colors.white), // Set text color to white
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Set background color to blue
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showCreateAppointmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchDentists(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return AlertDialog(
                title: const Text('Book Appointment'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: SpinKitFadingCube(
                          color: Colors.black,
                          size: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return AlertDialog(
                title: const Text('Book Appointment'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Error: ${snapshot.error}'),
                    ],
                  ),
                ),
              );
            } else {
              List<Map<String, dynamic>> dentists = snapshot.data ?? [];
              return AlertDialog(
                title: const Text('Book Appointment'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _cprControllerbook,
                        decoration:
                            InputDecoration(labelText: 'Enter Patient CPR'),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: _dateController,
                                style: const TextStyle(fontSize: 16),
                                decoration: InputDecoration(
                                  labelText: 'Select Appointment Date',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  enabled: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextField(
                        controller: _statController,
                        decoration:
                            InputDecoration(labelText: 'Start appointment'),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _endController,
                        decoration:
                            InputDecoration(labelText: 'End appointment'),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<int>(
                        value: selectedDentistIndex >= 0
                            ? selectedDentistIndex
                            : null,
                        items: dentists.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, dynamic> dentist = entry.value;
                          return DropdownMenuItem<int>(
                            value: index,
                            child: Text(dentist['name']),
                          );
                        }).toList(),
                        onChanged: (int? index) {
                          setState(() {
                            if (index != null) {
                              selectedDentistIndex = index;
                              selectedDentistId = dentists[index]['id'];
                              selectedDentistName = dentists[index]['name'];
                            }
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Select Dentist',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      saveAppointment();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }


void saveAppointment() async {
  try {
    String uid = '';

    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('CPR', isEqualTo: _cprControllerbook.text)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      uid = userSnapshot.docs.first.id;
    }

    // Convert start and end times to numbers
    int startHour = int.parse(_statController.text);
    int endHour = int.parse(_endController.text);

    // Parse date string with custom format
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    DateTime date = dateFormat.parse(_dateController.text);

    // Convert date to a Firestore timestamp
    Timestamp dateTimestamp = Timestamp.fromDate(date);

    await FirebaseFirestore.instance.collection('appointments').add({
      'uid': uid,
      'did': selectedDentistId,
      'hour': startHour,
      'end': endHour,
      'date': dateTimestamp,
    });
  } catch (e) {
    print("Error saving appointment: $e");
  }
}


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy')
            .format(picked); // Format date and set text in text field
      });
    }
  }

  void showAppointmentInfoDialog(BuildContext context, String patientName,
      String appointmentDate, String appointmentTime, String dentistName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Appointment Information'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Patient Name: $patientName'),
                Text('Appointment Date: $appointmentDate'),
                Text('Appointment Time: $appointmentTime'),
                Text('Dentist:Dr.$dentistName'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void showSearchAppointmentDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search Appointment by CPR'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _cprController,
                  decoration: InputDecoration(labelText: 'Enter Patient CPR'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Search for user by CPR to get UID
                String cpr = _cprController.text;
                QuerySnapshot userSnapshot = await FirebaseFirestore.instance
                    .collection('user')
                    .where('CPR', isEqualTo: cpr)
                    .get();

                if (userSnapshot.docs.isNotEmpty) {
                  // Get UID
                  String uid = userSnapshot.docs.first.id;

                  // Query Firestore to get appointment data using UID
                  QuerySnapshot appointmentsSnapshot = await FirebaseFirestore
                      .instance
                      .collection('appointments')
                      .where('uid', isEqualTo: uid)
                      .where('date',
                          isGreaterThan: DateTime
                              .now()) // Filter out appointments that have passed
                      .get();

                  // Check if appointment found
                  if (appointmentsSnapshot.docs.isNotEmpty) {
                    // Get appointment data
                    var (appointmentData as Map<String, dynamic>) =
                        appointmentsSnapshot.docs.first.data();
                    Timestamp timestamp = appointmentData[
                        'date']; // Assuming 'date' field is a Timestamp
                    DateTime dateTime = timestamp.toDate();
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(dateTime);

                    String appointmentTime = appointmentData['hour'].toString();
                    String dentistId = appointmentData['did'];

                    // Query Firestore to get the name of the dentist using dentistId
                    DocumentSnapshot dentistSnapshot = await FirebaseFirestore
                        .instance
                        .collection('user')
                        .doc(dentistId)
                        .get();

                    if (dentistSnapshot.exists) {
                      String dentistName = (dentistSnapshot.data()
                          as Map<String, dynamic>)['FullName'];

                      // Query Firestore to get the patient's name using UID
                      DocumentSnapshot patientSnapshot = await FirebaseFirestore
                          .instance
                          .collection('user')
                          .doc(uid)
                          .get();

                      if (patientSnapshot.exists) {
                        String patientName = (patientSnapshot.data()
                            as Map<String, dynamic>)['FullName'];

                        // Show appointment information dialog
                        showAppointmentInfoDialog(context, patientName,
                            formattedDate, appointmentTime, dentistName);
                      }
                    }
                  }
                }
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  void showEditAppointmentDialog(BuildContext context) {
    TextEditingController cprController =
        TextEditingController(); // Controller for CPR input

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Appointment'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: cprController,
                  decoration: InputDecoration(labelText: 'Enter Patient CPR'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                    const SizedBox(width: 8), // Add some space between buttons
                    ElevatedButton(
                      onPressed: () async {
                        // Check CPR validity or existence in the system
                        String patientCPR = cprController.text;
                        if (await isValidCPR(patientCPR)) {
                          // CPR is valid, proceed to show appointment form
                          Navigator.of(context).pop();
                          showAppointmentForm(context, patientCPR);
                        } else {
                          // Handle invalid CPR input
                          showErrorDialog(context, 'Invalid CPR');
                        }
                      },
                      child: const Text('Next'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> isValidCPR(String cpr) async {
    // Replace with your actual user collection path
    final userSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('CPR', isEqualTo: cpr)
        .get();

    return userSnapshot.docs.isNotEmpty;
  }

  void showAppointmentForm(BuildContext context, String patientCPR) async {
    // Retrieve the user ID based on CPR
    final userSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('CPR', isEqualTo: patientCPR)
        .get();

    if (userSnapshot.docs.isEmpty) {
      showErrorDialog(context, 'User not found');
      return;
    }

    String userId = userSnapshot.docs.first.id;

    // Retrieve upcoming appointments for the user
    final now =
        Timestamp.fromDate(DateTime.now().toUtc().add(Duration(hours: 3)));
    print('Current Timestamp: $now'); // Debugging line

    final appointmentsSnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('uid', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: now)
        .get();

    print('Appointments Snapshot: ${appointmentsSnapshot.docs.length}');

    if (appointmentsSnapshot.docs.isEmpty) {
      showErrorDialog(context, 'No upcoming appointments found');
      return;
    }

    // Proceed to show the first appointment form (or adapt to show a list of appointments)
    final appointment = appointmentsSnapshot.docs.first;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Appointment'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Patient CPR: $patientCPR'),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    _selectDate(context); // Function to show date picker dialog
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _dateController,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            labelText: 'Select Appointment Date',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            enabled: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: TextEditingController(text: appointment['hour']),
                  decoration: InputDecoration(labelText: 'Start appointment'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: TextEditingController(text: appointment['end']),
                  decoration: InputDecoration(labelText: 'End appointment'),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField(
                  value: appointment['did'], // Assuming 'did' is the dentist ID
                  items: _dentists.map((dentist) {
                    return DropdownMenuItem(
                      value: dentist,
                      child: Text(dentist),
                    );
                  }).toList(),
                  onChanged: (selectedDentist) {
                    appointment.reference.update({'did': selectedDentist});
                  },
                  decoration: const InputDecoration(
                    labelText: 'Select Dentist',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Save edited appointment details
                await appointment.reference.update({
                  'date': Timestamp.fromDate(_selectedDate),
                  'hour': appointment['hour'],
                  'end': appointment['end'],
                  'did': appointment['did'],
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void showCancelAppointmentDialog(BuildContext context) {
    TextEditingController cprControllerCancel =
        TextEditingController(); // Controller for CPR input
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Appointment'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: cprControllerCancel,
                  decoration: InputDecoration(labelText: 'Enter Patient CPR'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                QuerySnapshot userSnapshot = await FirebaseFirestore.instance
                    .collection('user')
                    .where('CPR', isEqualTo: cprControllerCancel.text)
                    .get();

                if (userSnapshot.docs.isNotEmpty) {
                  // Get UID
                  String uid = userSnapshot.docs.first.id;

                  // Query Firestore to get appointment data using UID
                  QuerySnapshot appointmentsSnapshot = await FirebaseFirestore
                      .instance
                      .collection('appointments')
                      .where('uid', isEqualTo: uid)
                      .where('date',
                          isGreaterThan: DateTime
                              .now()) // Filter out appointments that have passed
                      .get();

                  // Check if appointment found
                  if (appointmentsSnapshot.docs.isNotEmpty) {
                    // Get appointment data
                    var (appointmentData as Map<String, dynamic>) =
                        appointmentsSnapshot.docs.first.data();
                    String appointmentId = appointmentsSnapshot
                        .docs.first.id; // Get appointment ID
                    Timestamp timestamp = appointmentData[
                        'date']; // Assuming 'date' field is a Timestamp
                    DateTime dateTime = timestamp.toDate();
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(dateTime);

                    String appointmentTime = appointmentData['hour'].toString();;
                    String dentistId = appointmentData['did'];

                    // Query Firestore to get the name of the dentist using dentistId
                    DocumentSnapshot dentistSnapshot = await FirebaseFirestore
                        .instance
                        .collection('user')
                        .doc(dentistId)
                        .get();

                    if (dentistSnapshot.exists) {
                      String dentistName = (dentistSnapshot.data()
                          as Map<String, dynamic>)['FullName'];

                      // Query Firestore to get the patient's name using UID
                      DocumentSnapshot patientSnapshot = await FirebaseFirestore
                          .instance
                          .collection('user')
                          .doc(uid)
                          .get();

                      if (patientSnapshot.exists) {
                        String patientName = (patientSnapshot.data()
                            as Map<String, dynamic>)['FullName'];

                        // Show appointment information dialog
                        showAppointmentInfoCancelDialog(
                            context,
                            patientName,
                            formattedDate,
                            appointmentTime as String,
                            dentistName,
                            appointmentId);
                      }
                    }
                  }
                }
              },
              child: const Text('Next'),
            ),
          ],
        );
      },
    );
  }

  showAppointmentInfoCancelDialog(
      BuildContext context,
      String patientName,
      String formattedDate,
      String appointmentTime,
      String dentistName,
      String appointmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Appointment Information'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Patient Name: $patientName'),
                Text('Appointment Date: $formattedDate'),
                Text('Appointment Time: $appointmentTime'),
                Text('Dentist:Dr. $dentistName'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () async {
                // Remove appointment from Firestore
                await FirebaseFirestore.instance
                    .collection('appointments')
                    .doc(appointmentId)
                    .delete();

                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Appointment canceled successfully'),
                  ),
                );
              },
              child: const Text(
                'Confirm',
                style:
                    TextStyle(color: Colors.red), // Set the text color to red
              ),
            ),
          ],
        );
      },
    );
  }
}

class _dentists {
  static map(DropdownMenuItem<Object> Function(dynamic dentist) param0) {}
}
