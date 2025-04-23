import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:senior/functions/booking/getdentist.dart';

import '../../../const/app_colors.dart';

class DentistSelection extends StatefulWidget {
  final Function(String, String) onDentistSelected;

  const DentistSelection({super.key, required this.onDentistSelected});

  @override
  _DentistSelectionState createState() => _DentistSelectionState();
}

class _DentistSelectionState extends State<DentistSelection> {
  String? selectedDentistId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getDentists(context),
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

        final dentists = snapshot.data ?? [];
        if (dentists.isEmpty) {
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
                childAspectRatio: 5.0,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: dentists.length,
              itemBuilder: (context, index) {
                return _buildDentistCard(
                  context,
                  dentists[index],
                );
              },
            );
          },
        );
      },
    );
  }

  int _calculateCrossAxisCount(double width) {
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 1;
  }

  Widget _buildDentistCard(
    BuildContext context,
    Map<String, dynamic> dentist,
  ) {
    final isSelected = selectedDentistId == dentist['id'];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedDentistId = dentist['id'];
          });
          widget.onDentistSelected(dentist['id'], dentist['Name']);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSelected
                  ? [
                      Colors.green.withOpacity(0.7),
                      Colors.green.withOpacity(0.9)
                    ]
                  : [
                      AppColors.primaryColor,
                      AppColors.primaryColor.withOpacity(0.8)
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.whiteColor.withOpacity(0.8),
                child: Text(
                  dentist['Name'][0],
                  style: TextStyle(
                    color: isSelected
                        ? Colors.green
                        : Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Dr. ${dentist['Name']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isSelected ? Colors.white : AppColors.whiteColor,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color:
                    isSelected ? Colors.white : Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
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
            'Error loading dentists: $error',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person_off,
            color: Colors.grey,
            size: 48,
          ),
          SizedBox(height: 16),
          Text(
            'No dentists available at the moment',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
