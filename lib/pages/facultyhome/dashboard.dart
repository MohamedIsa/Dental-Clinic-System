import 'package:flutter/material.dart';
import '../../functions/dashboard/getrole.dart';
import '../../utils/data.dart';
import '../widgets/static/dentistlist.dart';
import '../widgets/static/facilitypage.dart';
import '../widgets/static/today_appointment.dart';
// import '../widgets/static/today_appointment.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String role = '';

  @override
  void initState() {
    super.initState();
    Data.checkUserAndNavigate(context);
    getRole().then((roles) {
      if (roles != null) {
        setState(() {
          role = roles;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FacilityPage(
      widget: Expanded(
        flex: 9,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
          ),
          child: role == 'admin' || role == 'recptionist'
              ? TodayAppointmentPage()
              : null,
        ),
      ),
      widget1: Expanded(
        flex: 2,
        child: role == 'admin' || role == 'recptionist'
            ? DentistsDataTable()
            : Container(),
      ),
    );
  }
}
