import 'package:flutter/material.dart';
import 'package:senior/clinic_details_card.dart';
import 'package:senior/today_appointment.dart';

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 18),
            ClinicDetailsCard(),
            SizedBox(height: 18),
            TodayAppointmentPage(),
            SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}
