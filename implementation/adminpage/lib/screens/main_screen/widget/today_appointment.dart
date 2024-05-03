import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TodayAppointmentPage extends StatelessWidget {
  const TodayAppointmentPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300, // Set a specific height
      child: const AppointmentCalendar(),
    );
  }
}

class AppointmentCalendar extends StatelessWidget {
  const AppointmentCalendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.timelineDay,
      timeSlotViewSettings: const TimeSlotViewSettings(
        startHour: 9,
        endHour: 18,
      ),
    );
  }
}
