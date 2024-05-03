import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentCalender extends StatelessWidget {
  const AppointmentCalender({Key? key});

  @override
  Widget build(BuildContext context) {
    // Sample appointment data
    final List<Appointment> appointments = <Appointment>[
      Appointment(
        startTime: DateTime.now().subtract(Duration(hours: 1)),
        endTime: DateTime.now().add(Duration(hours: 1)),
        subject: 'Meeting with Client',
        color: Colors.blue,
      ),
      Appointment(
        startTime: DateTime.now().add(Duration(hours: 2)),
        endTime: DateTime.now().add(Duration(hours: 3)),
        subject: 'Team Standup',
        color: Colors.green,
      ),
      // Add more appointments as needed
    ];

    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: 400, // Set a fixed height for the calendar
          child: SfCalendar(
            view: CalendarView.timelineWeek,
            timeSlotViewSettings: const TimeSlotViewSettings(
              startHour: 9,
              endHour: 18,
            ),
            // Define non-working days (Saturday and Sunday)
            dataSource: AppointmentDataSource(appointments),
          ),
        ),
      ),
    );
  }
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
