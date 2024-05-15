import 'package:flutter/material.dart';
import 'package:senior/dentist/treatment_record_model.dart';

class EditTreatmentRecordPage extends StatefulWidget {
  final TreatmentRecord treatmentRecord;

  EditTreatmentRecordPage({required this.treatmentRecord});

  @override
  _EditTreatmentRecordPageState createState() =>
      _EditTreatmentRecordPageState();
}

class _EditTreatmentRecordPageState extends State<EditTreatmentRecordPage> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _patientNameController = TextEditingController();
  TextEditingController _cprController = TextEditingController();
  TextEditingController _dentistController = TextEditingController();
  TextEditingController _treatmentTypeController = TextEditingController();
  TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with existing data
    _dateController.text = widget.treatmentRecord.date;
    _timeController.text = widget.treatmentRecord.time;
    _patientNameController.text = widget.treatmentRecord.patientname;
    _cprController.text = widget.treatmentRecord.CPR;
    _dentistController.text = widget.treatmentRecord.dentist;
    _treatmentTypeController.text = widget.treatmentRecord.treatmentType;
    _notesController.text = widget.treatmentRecord.notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Treatment Record'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date'),
            ),
            TextFormField(
              controller: _timeController,
              decoration: InputDecoration(labelText: 'Time'),
            ),
            TextFormField(
              controller: _patientNameController,
              decoration: InputDecoration(labelText: 'Patient Name'),
            ),
            TextFormField(
              controller: _cprController,
              decoration: InputDecoration(labelText: 'Patient CPR'),
            ),
            TextFormField(
              controller: _dentistController,
              decoration: InputDecoration(labelText: 'Dentist'),
            ),
            TextFormField(
              controller: _treatmentTypeController,
              decoration: InputDecoration(labelText: 'Treatment Type'),
            ),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: null,
            ),
            TextFormField(
              // For Attachments
              // Add your attachment-related logic here
              decoration: InputDecoration(labelText: 'Attachments'),
            ),
            SizedBox(height: 16),
          Center( // Center the button horizontally
            child: ElevatedButton(
              onPressed: () {
                // Save changes and navigate back
                saveChanges();
              },
              child: Text('Save Changes'),
            ),
          ),
          ],
        ),
      ),
    );
  }

  void saveChanges() {
    // Save changes logic
    Navigator.pop(context);
  }
}
