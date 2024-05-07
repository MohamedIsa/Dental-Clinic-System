import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:senior/admin/dentistlist.dart';
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
                          flex: 3,
                          child: SideMenuWidget(),
                        ),
                        Expanded(
                          flex: 10,
                          child: TodayAppointmentPage(),
                        ),
                        Expanded(
                          flex: 5,
                          child: DentistsDataTable(),
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
          return SpinKitFadingCube(
            size: 30,
            color: Colors.blue,
          );
        }
      },
    );
  }
}
