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
  TextEditingController _dateController =
      TextEditingController(); // Controller for CPR text field
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
              onPressed: widget.onViewAppointmentsPressed,
              child: const Text('View Appointment'),
            ),
          ),
          const SizedBox(width: 16),
          ButtonTheme(
            minWidth: 120,
            child: ElevatedButton(
              onPressed: widget.onEditAppointmentPressed,
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
                const TextField(
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
                const TextField(
                  decoration: InputDecoration(labelText: 'Start appointment'),
                ),
                const SizedBox(height: 20),
                const TextField(
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
}
