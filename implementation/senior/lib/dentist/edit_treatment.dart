import 'package:flutter/material.dart';
import 'package:senior/dentist/treatment_record_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class EditTreatmentRecordPage extends StatefulWidget {
  final TreatmentRecord treatmentRecord;
  final String treatmentId;

  EditTreatmentRecordPage({
    required this.treatmentRecord,
    required this.treatmentId,
  });

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
  String _attachment = '';

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _attachment = image.path;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = widget.treatmentRecord.date;
    _timeController.text = widget.treatmentRecord.time;
    _patientNameController.text = widget.treatmentRecord.patientname;
    _cprController.text = widget.treatmentRecord.CPR;
    _dentistController.text = widget.treatmentRecord.dentist;
    _treatmentTypeController.text = widget.treatmentRecord.treatmentType;
    _notesController.text = widget.treatmentRecord.notes;
    _attachment = widget.treatmentRecord.attachments.join(', ');
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
              decoration: InputDecoration(
                labelText: 'Attachments',
                suffixIcon: IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: _pickImage,
                ),
              ),
              controller: TextEditingController(text: _attachment),
              readOnly:false,
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
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

  void saveChanges() async {
    final cpr = _cprController.text;
    final userSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('CPR', isEqualTo: cpr)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      final updatedTreatmentData = {
        'date': _dateController.text,
        'time': _timeController.text,
        'patientName': _patientNameController.text,
        'CPR': cpr,
        'dentist': _dentistController.text,
        'treatmentType': _treatmentTypeController.text,
        'notes': _notesController.text,
        'attachment': _attachment,
      };
      await FirebaseFirestore.instance
          .collection('treatment')
          .doc(widget.treatmentId)
          .update(updatedTreatmentData);

      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Patient CPR not found.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
