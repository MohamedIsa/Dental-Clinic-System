import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:senior/const/app_colors.dart';
import 'package:senior/functions/booking/getdates.dart';

class DateSelection extends StatelessWidget {
  final String selectedDentistId;
  final Function(DateTime) onDateSelected;

  const DateSelection({
    super.key,
    required this.selectedDentistId,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DateTime>>(
      future: getAvailableDates(context, selectedDentistId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SpinKitPulse(
              color: Colors.blue,
              size: 40.0,
            ),
          );
        }

        final dates = snapshot.data ?? [];
        if (dates.isEmpty) {
          return _buildEmptyWidget();
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount =
                _calculateCrossAxisCount(constraints.maxWidth);

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 5.0, // Adjusted aspect ratio
                crossAxisSpacing: 4,
                mainAxisSpacing: 8,
              ),
              itemCount: dates.length,
              itemBuilder: (context, index) {
                final date = dates[index];
                return _buildDateCard(context, date);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildDateCard(BuildContext context, DateTime date) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => onDateSelected(date),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor,
                AppColors.primaryColor.withOpacity(0.8)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('EEE').format(date),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMM d').format(date),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return const Center(
      child: Text(
        'No available dates for selected dentist.',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
    );
  }

  int _calculateCrossAxisCount(double maxWidth) {
    if (maxWidth > 600) {
      return 3;
    } else if (maxWidth > 400) {
      return 2;
    } else {
      return 1;
    }
  }
}
