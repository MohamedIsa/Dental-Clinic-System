import 'package:senior/receptionist/header_widget.dart';
import 'package:senior/receptionist/patient_button_widget.dart';
import 'package:senior/receptionist/patient_list.dart';
import 'package:senior/receptionist/side_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReceptionistPatientPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection('user').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final fullName = snapshot.data?.get('FullName') ?? '';
          final firstName = fullName.split(' ')[0];
          return Scaffold(
            appBar: HeaderWidget(userName: firstName),
            body: const SafeArea(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ReceptionistSideMenuWidget(),
                  ),
                  Expanded(
                    flex: 9,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: 30), // Set the desired spacing value
                          child: PatientButtonsWidget(
                          ),
                        ),
                        PatientsDataTable(
                          
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
