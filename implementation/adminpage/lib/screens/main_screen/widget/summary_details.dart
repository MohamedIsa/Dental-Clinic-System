import 'package:adminpage/screens/main_screen/widget/custom_card_widget.dart';
import 'package:flutter/material.dart';

class SummaryDetails extends StatelessWidget {
  const SummaryDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: Color.fromARGB(255, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildDetails('New Patient', '50'),
          buildDetails('Doctor Avilaible', '5'),
          buildDetails('Today Appointments', '10'),
        ],
      ),
    );
  }

  Widget buildDetails(String key, String value) {
    return Column(
      children: [
        Text(
          key,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        const SizedBox(height: 2,width: 100,),
        Text(
          value,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
