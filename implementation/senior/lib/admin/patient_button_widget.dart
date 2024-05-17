import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:senior/admin/patient_details_button.dart';
import 'package:senior/admin/patient_model.dart';
import 'dart:math';

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
    String searchCpr = '';
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
                    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                        .collection('user')
                        .where('CPR', isEqualTo: searchCpr)
                        .get();

                    if (querySnapshot.docs.isNotEmpty) {
                      DocumentSnapshot userSnapshot = querySnapshot.docs.first;
                      String uid = userSnapshot.id;
                      DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
                          .collection('user')
                          .doc(uid)
                          .get();
                      PatientData patientData = PatientData.fromSnapshot(userDataSnapshot);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientDetailsPage(
                            patient: patientData,
                            user: FirebaseAuth.instance.currentUser!,
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
                        content: Text('An error occurred. Please try again later.'),
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
    String phoneNumber = '';
    String email = '';
    String? selectedGender;

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: ['Male', 'Female']
                      .map((gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  onChanged: (value) {
                    selectedGender = value!;
                  },
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
                    selectedGender != null &&
                    phoneNumber.isNotEmpty &&
                    email.isNotEmpty) {
                  try {
                    // Generate a random password
                    String randomPassword = generateRandomPassword();

                    // Create the user in Firebase Authentication
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email,
                      password: randomPassword,
                    );

                    // Send a password reset email to the user
                    await userCredential.user?.sendEmailVerification();
                    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

                    // Add data to 'user' collection in Firestore
                    DocumentReference userRef = FirebaseFirestore.instance
                        .collection('user')
                        .doc(userCredential.user?.uid);

                    await userRef.set({
                      'FullName': name,
                      'CPR': cpr,
                      'DOB': birthDay,
                      'Gender': selectedGender,
                      'Phone': phoneNumber,
                      'Email': email,
                    });

                    // Add UID to 'patient' collection in Firestore
                    await FirebaseFirestore.instance
                        .collection('patient')
                        .doc(userCredential.user?.uid)
                        .set({
                      'uid': userCredential.user?.uid,
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
                        content: Text('An error occurred. Please try again later.'),
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

  String generateRandomPassword({int length = 12}) {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length)),
      ),
    );
  }
}
