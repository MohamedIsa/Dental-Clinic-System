import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:senior/const/app_colors.dart';

import '../../../functions/booking/bookingfunctions.dart';

class TimeSelection extends StatelessWidget {
  final String selectedDentistId;
  final DateTime selectedDate;
  final Function(int) onTimeSelected;

  const TimeSelection({
    super.key,
    required this.selectedDentistId,
    required this.selectedDate,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<int>>>(
      future: getAvailableTimeSlots(selectedDentistId, selectedDate),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SpinKitPulse(
              color: Colors.blue,
              size: 40.0,
            ),
          );
        }

        if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error.toString());
        }

        final timeSlots = snapshot.data ?? [];
        if (timeSlots.isEmpty) {
          return _buildEmptyWidget();
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount =
                _calculateCrossAxisCount(constraints.maxWidth);
            final allSlots = timeSlots.expand((x) => x).toList();

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 2.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: allSlots.length,
              itemBuilder: (context, index) {
                return _buildTimeCard(context, allSlots[index]);
              },
            );
          },
        );
      },
    );
  }

  int _calculateCrossAxisCount(double width) {
    if (width > 1200) return 6;
    if (width > 900) return 5;
    if (width > 600) return 4;
    if (width > 400) return 3;
    return 2;
  }

  Widget _buildTimeCard(BuildContext context, int hour) {
    final isPM = hour >= 12;
    final displayHour = hour > 12 ? hour - 12 : hour;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => onTimeSelected(hour),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor.withOpacity(0.7),
                AppColors.primaryColor.withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$displayHour:00',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                isPM ? 'PM' : 'AM',
                style: TextStyle(
                  color: Theme.of(context).primaryColor.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading time slots: $error',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.access_time,
              color: Colors.grey[400],
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'No available time slots for ${DateFormat('MMMM d').format(selectedDate)}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please select a different date',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
