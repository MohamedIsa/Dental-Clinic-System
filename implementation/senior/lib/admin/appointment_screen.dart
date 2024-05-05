import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:senior/admin/appointment.dart';
import 'package:flutter/material.dart';
import 'package:senior/admin/appointment_buttons_widget.dart';
import 'package:senior/admin/side_menu_widget.dart';
import 'package:senior/admin/header_widget.dart';


class AppointmentPage extends StatelessWidget {
  const AppointmentPage({Key? key});

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
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: SideMenuWidget(),
            ),
            Expanded(
              flex: 9,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 50), // Add desired top spacing value
                    child: AppointmentButtonsWidget(),
                  ),
                  SizedBox(height: 20), // Add desired spacing between the buttons and calendar
                  Expanded(
                    child: AppointmentCalender(),
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
        } 
      );
  }
}