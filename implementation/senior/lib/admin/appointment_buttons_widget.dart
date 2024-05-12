import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

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
  List<String> _dentists = []; // List of dentists

  @override
  void initState() {
    super.initState();
    fetchDentists(); // Fetch dentists when the widget initializes
  }

  void fetchDentists() async {
    try {
      // Fetch all documents from "dentist" collection
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('dentist').get();

      // Temporary list to hold dentist names
      List<String> tempList = [];

      // Loop through the documents and add dentist names to the temporary list
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        String userId = doc.id;
        // Check if the user exists in the "user" collection
        DocumentSnapshot<Object?> userSnapshot = await FirebaseFirestore
            .instance
            .collection('user')
            .doc(userId)
            .get();
        if (userSnapshot.exists && userSnapshot.data() != null) {
          // Cast the data to the desired type
          Map<String, dynamic> userData =
              userSnapshot.data()! as Map<String, dynamic>;
          // If user is found and widget is still mounted, get their full name
          if (userData.containsKey('FullName')) {
            String dentistName = userData['FullName'];
            tempList.add(dentistName);
          }
        }
      }

      // Update the _dentists list only if the widget is still mounted
      if (mounted) {
        setState(() {
          _dentists = tempList;
        });
      }
    } catch (e) {
      print("Error fetching dentists: $e");
    }
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
        return AlertDialog(
          title: const Text('Book Appointment'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _cprControllerbook,
                  decoration: InputDecoration(labelText: 'Enter Patient CPR'),
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
                  decoration: InputDecoration(labelText: 'Start appointment'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _endController,
                  decoration: InputDecoration(labelText: 'End appointment'),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField(
                  value: _dentists.isNotEmpty
                      ? _dentists[0]
                      : null, // Provide default value or null if list is empty
                  items: _dentists.map((dentist) {
                    return DropdownMenuItem(
                      value: dentist,
                      child: Text(dentist),
                    );
                  }).toList(),
                  onChanged: (selectedDentist) {
                    setState(() {
                      // Handle dentist selection
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
                // Save edited appointment details
                String patientCPR = _cprControllerbook.text;
                DateTime appointmentDate = _selectedDate;
                String selectedDentist =
                    _dentists[0]; // Placeholder, update with selected dentist
                // Save to Firestore or perform desired action
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
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

  void showAppointmentInfoDialog(BuildContext context) {
    // Simulated appointment information
    String appointmentTime = "10:00 AM";
    String appointmentDate = "13/5/2024";
    String selectedDentist = _dentists[0];
    String patientName = "Mohamed Ali"; // Replace with actual patient name

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
                Text('Dentist: $selectedDentist'),
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

  void showSearchAppointmentDialog(BuildContext context) {
    showDialog(
      context: context,
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
              onPressed: () {
                // Search for appointment by CPR
                String cpr = _cprController.text;
                // Simulate appointment found
                bool appointmentFound =
                    true; // You need to implement the logic to check if appointment exists
                if (appointmentFound) {
                  // Show appointment information dialog
                  showAppointmentInfoDialog(context);
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
                      onPressed: () {
                        // Check CPR validity or existence in the system
                        String patientCPR = cprController.text;
                        if (isValidCPR(patientCPR)) {
                          // CPR is valid, proceed to show appointment form
                          Navigator.of(context).pop();
                          showAppointmentForm(context, patientCPR);
                        } else {
                          // Handle invalid CPR input
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Invalid CPR'),
                          ));
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

  void showAppointmentForm(BuildContext context, String patientCPR) {
    // Function to display appointment form with patient CPR
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
                  decoration: InputDecoration(labelText: 'Start appointment'),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(labelText: 'End appointment'),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField(
                  value: _dentists[0],
                  items: _dentists.map((dentist) {
                    return DropdownMenuItem(
                      value: dentist,
                      child: Text(dentist),
                    );
                  }).toList(),
                  onChanged: (selectedDentist) {
                    setState(() {
                      // Handle dentist selection
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
                // Save edited appointment details
                DateTime appointmentDate = _selectedDate;
                String selectedDentist =
                    _dentists[0]; // Placeholder, update with selected dentist
                // Save to Firestore or perform desired action
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  bool isValidCPR(String cpr) {
    // Add your CPR validation logic here
    return true; // Placeholder, replace with actual validation
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
              onPressed: () {
                // Search for appointment by CPR
                String cpr = cprControllerCancel.text;
                // Simulate appointment found
                bool appointmentFound =
                    true; // You need to implement the logic to check if appointment exists
                if (appointmentFound) {
                  showAppointmentInfoCancelDialog(context);
                }
              },
              child: const Text('Next'),
            ),
          ],
        );
      },
    );
  }

  void showAppointmentInfoCancelDialog(BuildContext context) {
    // Simulated appointment information
    String appointmentTime = "10:00 AM";
    String appointmentDate = "13/5/2024";
    String selectedDentist = _dentists[0];
    String patientName = "Mohamed Ali";

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
                Text('Dentist: $selectedDentist'),
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
              onPressed: () {
                Navigator.of(context).pop();
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
