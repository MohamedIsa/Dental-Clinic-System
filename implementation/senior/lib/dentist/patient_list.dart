
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senior/dentist/patient_details_button_dentist.dart';
import 'package:senior/dentist/patient_model.dart';

class PatientsDataTable extends StatelessWidget {
  const PatientsDataTable({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('patient').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        // If snapshot has no data or data is null
        if (!snapshot.hasData || snapshot.data == null) {
          return Text('No patient data found');
        }

        var patientDocs = snapshot.data!.docs;

        return Container(
          height: 300,
          child: ListView.builder(
            itemCount: patientDocs.length,
            itemBuilder: (context, index) {
              var patientDoc = patientDocs[index];
              var patientUID = patientDoc['uid'];
              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('user')
                    .doc(patientUID)
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (userSnapshot.hasError) {
                    return Text('Error: ${userSnapshot.error}');
                  }

                  var userData = userSnapshot.data!.data();
                  if (userData == null) {
                    return Text('User data not found');
                  }

                  // Now you have the user data from the "user" collection
                  return ListTile(
                    title: Text(userData['FullName'] ?? ''),
                    subtitle: Text(userData['CPR'] ?? ''),
                    onTap: () {
                      var patientData = PatientData(
                        id: patientUID, // Pass patient ID here
                        fullName: userData['FullName'] ?? '',
                        cpr: userData['CPR'] ?? '',
                        birthDay: userData['DOB'] ?? '',
                        gender: userData['Gender'] ?? '',
                        phoneNumber: userData['Phone'] ?? '',
                        email: userData['Email'] ?? '',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DentistPatientDetailsPage(
                            patient: patientData, 
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
