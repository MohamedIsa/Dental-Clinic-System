import 'package:adminpage/models/treatment_record_model.dart';
import 'package:flutter/material.dart';

class TreatmentRecordPage extends StatefulWidget {
  @override
  _TreatmentRecordPageState createState() => _TreatmentRecordPageState();
}

class _TreatmentRecordPageState extends State<TreatmentRecordPage> {
  // Dummy data for treatment records
  List<TreatmentRecord> treatmentRecords = [
    TreatmentRecord(
      date: '2024-04-27',
      dentist: 'Dr. Smith',
      treatmentType: 'Tooth Extraction',
      notes: 'Patient experienced mild discomfort during the procedure.',
    ),
    // Add more treatment records here...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treatment Records'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigate to add new treatment record page
              // Implementation required
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: treatmentRecords.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(treatmentRecords[index].treatmentType),
              subtitle: Text(treatmentRecords[index].date),
              onTap: () {
                // Navigate to treatment record details page
                // Implementation required
              },
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Edit treatment record
                  // Implementation required
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
