import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:senior/admin/side_menu_widget.dart';
import 'package:senior/admin/header_widget.dart';
import 'package:senior/admin/today_appointment.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('user').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final fullName = snapshot.data?.get('FullName') ?? '';
          final firstName = fullName.split(' ')[0];

          return Scaffold(
            appBar: HeaderWidget(userName: firstName),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 7,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: SideMenuWidget(),
                        ),
                        Expanded(
                          flex: 7,
                          child: TodayAppointmentPage(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20), // Add spacing
                  Text(
                    'Dentist Information',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10), // Add spacing
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('dentist').doc(uid).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // Check if user ID exists in dentist collection
                        if (snapshot.data!.exists) {
                          final fullName = snapshot.data?.get('FullName') ?? '';
                          final email = snapshot.data?.get('Email') ?? '';
                          return Column(
                            children: [
                              Text('Name: $fullName'),
                              Text('Email: $email'),
                            ],
                          );
                        } else {
                          return Text('Dentist not found');
                        }
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return SpinKitFadingCube(
                          size: 30,
                          color: Colors.blue,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return SpinKitFadingCube(
            size: 30,
            color: Colors.blue,
          );
        }
      },
    );
  }
}
