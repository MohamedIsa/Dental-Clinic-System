import 'package:adminpage/data/patient_data.dart'; // Import the patientInfo list
import 'package:adminpage/models/patient_model.dart';
import 'package:flutter/material.dart';

class PatientButtonsWidget extends StatelessWidget {
  final VoidCallback? onAddPatientPressed;
  final void Function(String cpr)? onSearchPatientPressed;

  const PatientButtonsWidget({
    Key? key,
    this.onAddPatientPressed,
    this.onSearchPatientPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonTheme(
            minWidth: 120,
            child: ElevatedButton(
              onPressed: onAddPatientPressed != null ? () => showAddPatientDialog(context) : null,
              child: const Text('Add New Patient'),
            ),
          ),
          const SizedBox(width: 16),
          ButtonTheme(
            minWidth: 120,
            child: ElevatedButton(
              onPressed: () => showSearchDialog(context),
              child: const Text('Search'),
            ),
          ),
        ],
      ),
    );
  }

  void showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String searchCPR = '';

        return AlertDialog(
          title: const Text('Search Patient by CPR'),
          content: TextField(
            onChanged: (value) {
              searchCPR = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter CPR number',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (searchCPR.isNotEmpty && onSearchPatientPressed != null) {
                  bool found = false;
                  for (var patient in patientInfo) {
                    if (patient.cpr == searchCPR) {
                      found = true;
                      onSearchPatientPressed!(searchCPR); // Use null-aware operator
                      break;
                    }
                  }
                  if (!found) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Patient with CPR $searchCPR not found.'),
                      ),
                    );
                  }
                }
                Navigator.pop(context);
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  void showAddPatientDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String cpr = '';
        String birthDay = '';
        String gender = '';
        String phoneNumber = '';
        String email = '';

        return AlertDialog(
          title: const Text('Add New Patient'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  name = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                onChanged: (value) {
                  cpr = value;
                },
                decoration: const InputDecoration(
                  labelText: 'CPR',
                ),
              ),
              TextField(
                onChanged: (value) {
                  birthDay = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Birth Day',
                ),
              ),
              TextField(
                onChanged: (value) {
                  gender = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Gender',
                ),
              ),
              TextField(
                onChanged: (value) {
                  phoneNumber = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                ),
              ),
              TextField(
                onChanged: (value) {
                  email = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (name.isNotEmpty &&
                    cpr.isNotEmpty &&
                    birthDay.isNotEmpty &&
                    gender.isNotEmpty &&
                    phoneNumber.isNotEmpty &&
                    email.isNotEmpty) {
                  final newPatient = PatientData(
                    fullName: name,
                    cpr: cpr,
                    birthDay: birthDay,
                    gender: gender,
                    phoneNumber: phoneNumber,
                    email: email,
                  );
                  patientInfo.add(newPatient);
                  onAddPatientPressed?.call(); // Use null-aware operator
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields.'),
                    ),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}