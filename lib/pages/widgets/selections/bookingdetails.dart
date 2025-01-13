import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../const/app_colors.dart';

class AppointmentDetails extends StatelessWidget {
  final String selectedDentistFirstName;
  final DateTime selectedDate;
  final int selectedHour;
  final String selectedDentistId;
  final bool showContainer;
  final bool showTime;

  const AppointmentDetails({
    super.key,
    required this.selectedDentistFirstName,
    required this.selectedDate,
    required this.selectedHour,
    required this.selectedDentistId,
    required this.showContainer,
    required this.showTime,
  });

  @override
  Widget build(BuildContext context) {
    if (!showContainer || !showTime) return const SizedBox.shrink();

    final isPM = selectedHour >= 12;
    final displayHour = selectedHour > 12 ? selectedHour - 12 : selectedHour;
    final timeString = '$displayHour:00 ${isPM ? 'PM' : 'AM'}';

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor.withOpacity(0.8),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.event_available,
                  color: Colors.white.withOpacity(0.9),
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Appointment\nSummary',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailRow(
              context,
              icon: Icons.person,
              label: 'Dentist',
              value: 'Dr. $selectedDentistFirstName',
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              context,
              icon: Icons.calendar_today,
              label: 'Day',
              value: DateFormat('EEEE').format(selectedDate),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              context,
              icon: Icons.calendar_today,
              label: 'Date',
              value: DateFormat('MMMM d, y').format(selectedDate),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              context,
              icon: Icons.access_time,
              label: 'Time',
              value: timeString,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.white.withOpacity(0.9),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Please arrive 10 minutes before your appointment time',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
