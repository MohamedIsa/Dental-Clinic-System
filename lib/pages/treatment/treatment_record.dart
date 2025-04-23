import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

import '../../models/treatment_record_model.dart';
import 'widgets/treatment_card.dart';
import 'widgets/treatment_details_dialog.dart';
import 'widgets/treatment_header.dart';

class TreatmentRecordPage extends StatefulWidget {
  @override
  _TreatmentRecordPageState createState() => _TreatmentRecordPageState();
}

class _TreatmentRecordPageState extends State<TreatmentRecordPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<TreatmentRecord> treatmentRecords = [];

  @override
  void initState() {
    super.initState();
    fetchTreatmentRecords();
  }

  void fetchTreatmentRecords() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('treatment').get();

      setState(() {
        treatmentRecords = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;

          return TreatmentRecord(
            treatmentId: doc.id,
            date: data['date'] ?? '',
            time: data['time'] ?? '',
            patientId: data['patientId'] ?? '',
            cpr: data['cpr'] ?? '',
            dentistId: data['dentistId'] ?? '',
            treatmentType: data['treatmentType'] ?? '',
            notes: data['notes'] ?? '',
            attachment: data['attachment'] as String?,
          );
        }).toList();
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100, Colors.white],
            stops: [0.0, 0.8],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TreatmentHeader(),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: treatmentRecords.length,
                itemBuilder: (context, index) {
                  final record = treatmentRecords[index];
                  return TreatmentCard(
                    record: record,
                    onTap: () => _showTreatmentDetails(record),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addNewTreatmentRecord() {
    context.go('/addtreatment');
  }

  void _showTreatmentDetails(TreatmentRecord record) {
    showDialog(
      context: context,
      builder: (context) => TreatmentDetailsDialog(record: record),
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
            Text('Patient CPR: ${treatmentRecord.cpr}'),
            Text('Treatment Type: ${treatmentRecord.treatmentType}'),
            Text('Description: ${treatmentRecord.notes}'),
            if (treatmentRecord.attachment != null &&
                treatmentRecord.attachment!.isNotEmpty) ...[
              SizedBox(height: 16),
              Text('Attachment:'),
              Image.network(
                treatmentRecord.attachment!,
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ],
            SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
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
