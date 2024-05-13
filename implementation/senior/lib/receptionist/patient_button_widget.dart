import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:senior/receptionist/patient_details_button.dart';
import 'package:senior/receptionist/patient_model.dart';

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
              onPressed: () => showAddPatientDialog(context),
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
                          builder: (context) => PatientDetailsPage(
                              patient: patientData,
                              user: FirebaseAuth.instance.currentUser!),
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

  void showAddPatientDialog(BuildContext context) {
    String name = '';
    String cpr = '';
    String birthDay = '';
    String gender = '';
    String phoneNumber = '';
    String email = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        var selectedGender;
        return AlertDialog(
          title: const Text('Add New Patient'),
          content: SingleChildScrollView(
            child: Column(
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
                DropdownButtonFormField<String>(
                    value: selectedGender,
                    decoration: InputDecoration(labelText: 'Gender'),
                    items: ['Male', 'Female']
                        .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            ))
                        .toList(),
                    onChanged: (value) {
                      selectedGender = value!;
                    }),
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
                if (name.isNotEmpty &&
                    cpr.isNotEmpty &&
                    birthDay.isNotEmpty &&
                    gender.isNotEmpty &&
                    phoneNumber.isNotEmpty &&
                    email.isNotEmpty) {
                  try {
                    // Add data to 'user' collection
                    DocumentReference userRef = await FirebaseFirestore.instance
                        .collection('user')
                        .add({
                      'FullName': name,
                      'CPR': cpr,
                      'DOB': birthDay,
                      'Gender': gender,
                      'phone': phoneNumber,
                      'Email': email,
                    });

                    // Get the UID of the added user
                    String uid = userRef.id;

                    // Add UID to 'patient' collection
                    await FirebaseFirestore.instance
                        .collection('patient')
                        .doc(uid)
                        .set({
                      'uid': uid,
                    });

                    // Invoke the onAddPatientPressed callback
                    if (onAddPatientPressed != null) {
                      onAddPatientPressed!();
                    }

                    Navigator.pop(context);
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
