import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  TextEditingController _cprController = TextEditingController();
  List<String> _dentists = [
    "Dentist 1",
    "Dentist 2",
    "Dentist 3"
  ]; // List of dentists

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
              child: const Text('Create Appointment'),
            ),
          ),
          const SizedBox(width: 16),
          ButtonTheme(
            minWidth: 120,
            child: ElevatedButton(
              onPressed: () => showSearchAppointmentDialog(context),
              child: const Text('View Appointment'),
            ),
          ),
          const SizedBox(width: 16),
          ButtonTheme(
            minWidth: 120,
            child: ElevatedButton(
              onPressed: () => showEditAppointmentDialog(),
              child: const Text('Edit Appointment'),
            ),
          ),
          const SizedBox(width: 16),
          ButtonTheme(
            minWidth: 120,
            child: ElevatedButton(
              onPressed: widget.onCancelAppointmentPressed,
              child: const Text('Cancel Appointment'),
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
          title: const Text('Create Appointment'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Patient CPR'),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    _selectDate(context); // Function to show date picker dialog
                  },
                  child: Row(
                    children: [
                      const Icon(
                          Icons.calendar_today), // Calendar icon for visual cue
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _dateController,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            labelText: 'Select Appointment Date',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black), // Change border color to black
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
                  decoration: InputDecoration(labelText: 'end appointment'),
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
                // Save appointment details
                String patientCPR = _dateController.text;
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
    String appointmentTime = "9:00 AM";
    String appointmentDate = "2024-05-12";
    String selectedDentist = _dentists[0];
    String patientName = "John Doe"; // Replace with actual patient name

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
                bool appointmentFound = true; // You need to implement the logic to check if appointment exists
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
    void showEditAppointmentDialog(BuildContext context) {
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
                decoration: InputDecoration(labelText: 'Patient CPR'),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _selectDate(context); // Function to show date picker dialog
                },
                child: Row(
                  children: [
                    const Icon(
                        Icons.calendar_today), // Calendar icon for visual cue
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _dateController,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          labelText: 'Select Appointment Date',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black), // Change border color to black
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
              String patientCPR = _dateController.text;
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

  }
}
