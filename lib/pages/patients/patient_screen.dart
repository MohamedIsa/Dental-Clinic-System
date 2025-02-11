import 'package:flutter/material.dart';
import '../widgets/static/facilitypage.dart';
import 'patient_list.dart';

class PatientScreen extends StatelessWidget {
  const PatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FacilityPage(
      widget: Expanded(
        flex: 9,
        child: Container(
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: PatientListPage(),
          ),
        ),
      ),
      widget1: const SizedBox.shrink(),
    );
  }
}
