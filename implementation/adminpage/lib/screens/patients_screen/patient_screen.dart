import 'package:adminpage/screens/header_widget.dart';
import 'package:adminpage/screens/patients_screen/widget/patient_button_widget.dart';
import 'package:adminpage/screens/patients_screen/widget/patient_list.dart';
import 'package:adminpage/screens/side_menu_widget.dart';
import 'package:flutter/material.dart';

class AdminPatientPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderWidget(userName: 'Ahmed Mahmood'),
      body: SafeArea(
        child: Row(
          children: [
            const Expanded(
              flex: 2,
              child: SideMenuWidget(),
            ),
            Expanded(
              flex: 9,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 30), // Set the desired spacing value
                    child: PatientButtonsWidget(),
                  ),
                  PatientsDataTable(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}