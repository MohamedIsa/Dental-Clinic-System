import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TodayAppointment {
  final DateTime startTime;
  final DateTime endTime;
  final String subject;
  final Color color;

  TodayAppointment({
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.color,
  });
}

class TodayAppointmentDataSource extends CalendarDataSource {
  TodayAppointmentDataSource(List<Appointment> appointments) {
    this.appointments = appointments;
  }
}
