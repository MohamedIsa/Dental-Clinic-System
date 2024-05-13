import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senior/dentist/patient_details_button_dentist.dart';
import 'package:senior/dentist/patient_model.dart';

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
        String searchCpr = '';

        return AlertDialog(
          title: const Text('Search Patient'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  searchCpr = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Enter CPR',
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
              onPressed: () async {
                if (searchCpr.isNotEmpty) {
                  try {
                    // Search for user based on CPR
                    QuerySnapshot querySnapshot = await FirebaseFirestore
                        .instance
                        .collection('user')
                        .where('CPR', isEqualTo: searchCpr)
                        .get();

                    if (querySnapshot.docs.isNotEmpty) {
                      // Retrieve the first matching user document
                      DocumentSnapshot userSnapshot = querySnapshot.docs.first;

                      // Get the UID from the user document
                      String uid = userSnapshot.id;

                      // Retrieve the user data from the user collection
                      DocumentSnapshot userDataSnapshot =
                          await FirebaseFirestore.instance
                              .collection('user')
                              .doc(uid)
                              .get();

                      // Create a PatientData object from the retrieved user data
                      PatientData patientData =
                          PatientData.fromSnapshot(userDataSnapshot);

                      // Navigate to the PatientDetailsPage and pass the patientData
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DentistPatientDetailsPage(
                              patient: patientData
                        ),
                      ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('User not found.'),
                        ),
                      );
                    }
                  } catch (e) {
                    print('Error: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('An error occurred. Please try again later.'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a CPR.'),
                    ),
                  );
                }
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }
}
