import 'package:senior/appointment.dart';
import 'package:flutter/material.dart';
import 'package:senior/appointment_buttons_widget.dart';
import 'package:senior/side_menu_widget.dart';
import 'package:senior/header_widget.dart';


class AppointmentPage extends StatelessWidget {
  const AppointmentPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HeaderWidget(userName: 'Ahmed Mahmood'),
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
  }
}