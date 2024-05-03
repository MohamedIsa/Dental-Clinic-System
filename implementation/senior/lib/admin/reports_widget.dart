import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ReportCard(
            title: 'Patient Demographics',
            onTap: () {
              // Navigate to patient demographics report
            },
          ),
          ReportCard(
            title: 'Appointment Summary',
            onTap: () {
              // Navigate to appointment summary report
            },
          ),
          // Add more report cards for other reports
        ],
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ReportCard({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}
