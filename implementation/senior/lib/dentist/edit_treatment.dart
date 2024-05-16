import 'package:flutter/material.dart';
import 'package:senior/dentist/treatment_record_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package

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
  String _attachment = ''; // Variable to store the attachment path

  // Function to open image picker and set the selected image path
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _attachment = image.path; // Set the selected image path
      });
    }
  }

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
              decoration: InputDecoration(
                labelText: 'Attachments',
                suffixIcon: IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: _pickImage, // Open image picker on button press
                ),
              ),
              controller: TextEditingController(text: _attachment),
              readOnly: true, // Make the text field read-only to display selected attachment
            ),
            SizedBox(height: 16),
            Center(
              // Center the button horizontally
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

  void saveChanges() async {
    final cpr = _cprController.text;

    // Check if CPR exists in user collection
    final userSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('CPR', isEqualTo: cpr)
        .get();
    final patientSnapshot = await FirebaseFirestore.instance
        .collection('patient')
        .where(userSnapshot.docs)
        .get();

    if (userSnapshot.docs.isNotEmpty && patientSnapshot.docs.isNotEmpty) {
      // Save changes logic
      // For example, update the treatment record in the database
      final updatedTreatmentData = {
        'date': _dateController.text,
        'time': _timeController.text,
        'patientname': _patientNameController.text,
        'CPR': cpr,
        'dentist': _dentistController.text,
        'treatmentType': _treatmentTypeController.text,
        'notes': _notesController.text,
        'did': userSnapshot.docs,
        'uid': patientSnapshot.docs,
        'attachment': _attachment, // Include attachment path in data
      };
      // Assuming there's a function to update treatment record in database
      await updateTreatmentRecord(updatedTreatmentData);

      Navigator.pop(context);
    } else {
      // CPR does not exist in user or patient collection, show an error message
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

  Future<void> updateTreatmentRecord(
      Map<String, dynamic> updatedData) async {
    // Assuming there's a function to update treatment record in the database
    // For example:
    // await FirebaseFirestore.instance.collection('treatmentRecords').doc(widget.treatmentRecord.id).update(updatedData);
  }
}
