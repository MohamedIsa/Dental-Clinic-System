import 'package:flutter/material.dart';

class AppointmentButtonsWidget extends StatelessWidget {
  final VoidCallback? onCreateAppointmentPressed;
  final VoidCallback? onViewAppointmentsPressed;
  final VoidCallback? onEditAppointmentPressed;
  final VoidCallback? onCancelAppointmentPressed;

  const AppointmentButtonsWidget({
    super.key,
    this.onCreateAppointmentPressed,
    this.onViewAppointmentsPressed,
    this.onEditAppointmentPressed,
    this.onCancelAppointmentPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonTheme(
            minWidth: 120,
            child: ElevatedButton(
              onPressed: onCreateAppointmentPressed,
              child: const Text('Create Appointment'),
            ),
          ),
          const SizedBox(width: 16),
          ButtonTheme(
            minWidth: 120,
            child: ElevatedButton(
              onPressed: onViewAppointmentsPressed,
              child: const Text('View Appointment'),
            ),
          ),
          const SizedBox(width: 16),
          ButtonTheme(
            minWidth: 120,
            child: ElevatedButton(
              onPressed: onEditAppointmentPressed,
              child: const Text('Edit Appointment'),
            ),
          ),
          const SizedBox(width: 16),
          ButtonTheme(
            minWidth: 120,
            child: ElevatedButton(
              onPressed: onCancelAppointmentPressed,
              child: const Text('Cancel Appointment'),
            ),
          ),
        ],
      ),
    );
  }
}