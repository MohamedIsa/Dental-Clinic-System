import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:senior/receptionist/patient_details_button.dart';
import 'package:senior/receptionist/patient_model.dart';
import 'package:senior/reuseable_widget.dart';
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
                          builder: (context) => PatientDetailsPage(
                            patient: patientData,
                            user: FirebaseAuth.instance.currentUser!,
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

  void showAddPatientDialog(BuildContext context) {
    String name = '';
    String cpr = '';
    String birthday = '';
    String phoneNumber = '';
    String email = '';
    String? selectedGender;
    String emailPattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    String CPRPattern = r'^\d{2}(0[1-9]|1[0-2])\d{5}$';
    String PhonePattern = r'^(66\d{6}|3[2-9]\d{6})$';
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
                    birthday = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Birthday',
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
                    birthday.isNotEmpty &&
                    selectedGender != null &&
                    phoneNumber.isNotEmpty &&
                    email.isNotEmpty) {
                  try {
                    // Generate a random password
                    String randomPassword = generateRandomPassword();
                    QuerySnapshot emailResult = await _firestore
                        .collection('user')
                        .where('Email', isEqualTo: email)
                        .get();
                    if (!RegExp(emailPattern).hasMatch(email)) {
                      showErrorDialog(context, 'Invalid email format.');
                      return;
                    }

                    if (emailResult.docs.isNotEmpty) {
                      showErrorDialog(context, 'Email already exists.');
                      return;
                    }

                    // Check if full name is not empty
                    if (name.isEmpty) {
                      showErrorDialog(context, 'Full name cannot be empty.');
                      return;
                    }

                    if (!RegExp(PhonePattern).hasMatch(phoneNumber)) {
                      showErrorDialog(context, 'Invalid Phone format.');
                      return;
                    }
                    if (isValidBirthday(birthday) == false) {
                      showErrorDialog(context, 'Invalid birthday.');
                      return;
                    }
                    if (!RegExp(CPRPattern).hasMatch(cpr)) {
                      showErrorDialog(context, 'Invalid CPR format.');
                      return;
                    }
                    QuerySnapshot result = await _firestore
                        .collection('user')
                        .where('CPR', isEqualTo: cpr)
                        .get();
                    if (result.docs.isNotEmpty) {
                      showErrorDialog(context, 'CPR already exists.');
                      return;
                    }

                    // Create the user in Firebase Authentication
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email,
                      password: randomPassword,
                    );

                    // Send a password reset email to the user
                    await userCredential.user?.sendEmailVerification();
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: email);

                    // Add data to 'user' collection in Firestore
                    DocumentReference userRef = FirebaseFirestore.instance
                        .collection('user')
                        .doc(userCredential.user?.uid);

                    await userRef.set({
                      'FullName': name,
                      'CPR': cpr,
                      'DOB': birthday,
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
                    {
                      print('Error: $e');

                      showErrorDialog(context, e.toString());
                    }
                  }
                } else {
                  print('Error: $e');

                  showErrorDialog(context, 'Please fill in all fields.');
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
    const characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length)),
      ),
    );
  }
}

bool isValidBirthday(String birthday) {
  // Check format with regex
  String birthdayPattern = r'^(0[1-9]|[12]\d|3[01])/(0[1-9]|1[0-2])/\d{4}$';
  RegExp regExp = RegExp(birthdayPattern);
  if (!regExp.hasMatch(birthday)) {
    return false;
  }

  // Parse the date string to DateTime
  List<String> parts = birthday.split('/');
  int day = int.tryParse(parts[0]) ?? 0;
  int month = int.tryParse(parts[1]) ?? 0;
  int year = int.tryParse(parts[2]) ?? 0;
  try {
    DateTime date = DateTime(year, month, day);
    // Check if the parsed date is valid
    if (date.year == year && date.month == month && date.day == day) {
      // Optionally, you can check if the date is not in the future
      DateTime currentDate = DateTime.now();
      if (date.isAfter(currentDate)) {
        return false; // Date is in the future
      }
      return true; // Valid date
    } else {
      return false; // Date components don't match
    }
  } catch (e) {
    return false; // Date parsing failed
  }
}