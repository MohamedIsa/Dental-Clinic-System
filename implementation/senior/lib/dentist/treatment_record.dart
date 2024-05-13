import 'package:flutter/material.dart';
import 'package:senior/dentist/add_treatment.dart';
import 'package:senior/dentist/edit_treatment.dart';
import 'package:senior/dentist/treatment_record_model.dart';

class TreatmentRecordPage extends StatefulWidget {
  @override
  _TreatmentRecordPageState createState() => _TreatmentRecordPageState();
}

class _TreatmentRecordPageState extends State<TreatmentRecordPage> {
  // Dummy data for treatment records
  List<TreatmentRecord> treatmentRecords = [
    TreatmentRecord(
      date: '2024-04-27',
      time: '10:00',
      patientname: 'Ali Mohamed',
      CPR: '020709773',
      dentist: 'Dr. Fatima Ali',
      treatmentType: 'Tooth Extraction',
      notes: 'Patient experienced mild discomfort during the procedure.',
      attachments: [], // Initialize attachments list
    ),
    // Add more treatment records here...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Treatment Records",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    addNewTreatmentRecord();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: treatmentRecords.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(treatmentRecords[index].treatmentType),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(treatmentRecords[index].date),
                        Text(treatmentRecords[index].CPR),
                      ],
                    ),
                    onTap: () {
                      // Navigate to treatment record details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TreatmentRecordDetailsPage(
                            treatmentRecord: treatmentRecords[index],
                          ),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Edit treatment record
                        // You can replace this with your edit function
                        editTreatmentRecord(treatmentRecords[index]);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Function to add a new treatment record
  void addNewTreatmentRecord() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTreatmentRecordPage(),
      ),
    );
  }

  // Function to edit treatment record
  void editTreatmentRecord(TreatmentRecord record) {
    // Perform the edit action here
    // For example, navigate to an edit page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTreatmentRecordPage(
          treatmentRecord: record,
        ),
      ),
    );
  }
}

class TreatmentRecordDetailsPage extends StatelessWidget {
  final TreatmentRecord treatmentRecord;

  TreatmentRecordDetailsPage({required this.treatmentRecord});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Treatment Record Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${treatmentRecord.date}'),
            Text('Time: ${treatmentRecord.time}'),
            Text('Patient Name: ${treatmentRecord.patientname}'),
            Text('Patient CPR: ${treatmentRecord.CPR}'),
            Text('Dentist: ${treatmentRecord.dentist}'),
            Text('Treatment Type: ${treatmentRecord.treatmentType}'),
            Text('Description: ${treatmentRecord.notes}'),
            // Display attachments if available
            if (treatmentRecord.attachments.isNotEmpty) ...[
              SizedBox(height: 16), // Add some space
              Text('Attachments:'),
              for (var attachment in treatmentRecord.attachments)
                Text('- $attachment'),
            ],
            SizedBox(height: 16), // Add some space
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  // Close the details page
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

