import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import DateFormat for date and time formatting

class AddTreatmentRecordPage extends StatefulWidget {
  @override
  _AddTreatmentRecordPageState createState() => _AddTreatmentRecordPageState();
}

class _AddTreatmentRecordPageState extends State<AddTreatmentRecordPage> {
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
    // Initialize date and time controllers with current date and time
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _timeController.text = DateFormat('HH:mm').format(DateTime.now());
    _fetchUserData();
  }

Future<void> _fetchUserData() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid != null) {
    final snapshot = await FirebaseFirestore.instance.collection('user').doc(uid).get();
    if (snapshot.exists) {
      final fullName = snapshot.get('FullName') ?? '';
      final firstName = fullName.split(' ')[0];
      setState(() {
        _dentistController.text = 'Dr. $firstName'; 
      });
    }
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
            decoration: InputDecoration(labelText: 'Attachments'),
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
              SizedBox(width: 16), // Add some space between buttons
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


  void saveChanges() {
    // Save changes logic
    Navigator.pop(context);
  }
}
