import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senior/dentist/patient_details_button_dentist.dart';
import 'package:senior/dentist/patient_model.dart';
import 'package:senior/reuseable_widget.dart';
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
    String searchCpr = '';
    String CPRPattern = r'^\d{2}(0[1-9]|1[0-2])\d{5}$';
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                    if (!RegExp(CPRPattern).hasMatch(searchCpr)) {
                      showErrorDialog(context, 'Invalid CPR format.');
                      return;
                    }

                    QuerySnapshot querySnapshot = await FirebaseFirestore
                        .instance
                        .collection('user')
                        .where('CPR', isEqualTo: searchCpr)
                        .get();

                    if (querySnapshot.docs.isNotEmpty) {
                      DocumentSnapshot userSnapshot = querySnapshot.docs.first;
                      String uid = userSnapshot.id;
                      DocumentSnapshot userDataSnapshot =
                          await FirebaseFirestore.instance
                              .collection('user')
                              .doc(uid)
                              .get();
                      PatientData patientData =
                          PatientData.fromSnapshot(userDataSnapshot);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DentistPatientDetailsPage(
                            patient: patientData,
                          ),
                        ),
                      );
                    } else {
                      showErrorDialog(context, 'User not found.');
                    }
                  } catch (e) {
                    print('Error: $e');

                    showErrorDialog(context, e.toString());
                  }
                } else {
                  showErrorDialog(context, 'Please enter a CPR.');
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