import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package

class AddTreatmentRecordPage extends StatefulWidget {
  @override
  _AddTreatmentRecordPageState createState() =>
      _AddTreatmentRecordPageState();
}

class _AddTreatmentRecordPageState extends State<AddTreatmentRecordPage> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _patientNameController = TextEditingController();
  TextEditingController _cprController = TextEditingController();
  TextEditingController _dentistController = TextEditingController();
  TextEditingController _treatmentTypeController = TextEditingController();
  TextEditingController _notesController = TextEditingController();
  String _attachment = ''; // Variable to store the attachment path

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _timeController.text = DateFormat('HH:mm').format(DateTime.now());
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final snapshot =
          await FirebaseFirestore.instance.collection('user').doc(uid).get();
      if (snapshot.exists) {
        final fullName = snapshot.get('FullName') ?? '';
        final firstName = fullName.split(' ')[0];
        setState(() {
          _dentistController.text = 'Dr. $firstName';
        });
      }
    }
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Treatment Record'),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      saveChanges();
                    },
                    child: Text('Add'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void saveChanges() async {

    final userSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('CPR', isEqualTo: _cprController.text)
        .get();
    final patientSnapshot = await FirebaseFirestore.instance
        .collection('patient')
        .where(userSnapshot.docs)
        .get();

    if (userSnapshot.docs.isNotEmpty && patientSnapshot.docs.isNotEmpty) {
      final patientDocId = userSnapshot.docs.first.id;
      final treatmentData = {
        'did': FirebaseAuth.instance.currentUser!.uid,
        'uid': patientDocId,
        'date': _dateController.text,
        'time': _timeController.text,
        'patientName': _patientNameController.text,
        'CPR': _cprController.text,
        'dentist': _dentistController.text,
        'treatmentType': _treatmentTypeController.text,
        'notes': _notesController.text,
        'attachment': _attachment, // Include attachment path in data
        // Add more fields as needed
      };
      await FirebaseFirestore.instance
          .collection('treatment')
          .add(treatmentData);
      Navigator.pop(context); // Close the page after adding treatment record
    } else {
      // CPR does not exist, show an error message or handle accordingly
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
