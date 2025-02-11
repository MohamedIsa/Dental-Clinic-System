import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/treatment_record_model.dart';
import '../../utils/data.dart';
import '../../utils/popups.dart';
import 'fetch_user.dart';
import 'image_handler.dart';

Future<void> handleSave(
  BuildContext context,
  TextEditingController _cprController,
  TextEditingController _treatmentTypeController,
  TextEditingController _notesController,
  ImageHandler _imageHandler,
  TextEditingController _dateController,
  TextEditingController _timeController,
) async {
  try {
    List<String> requiredFields = [];

    if (_cprController.text.isEmpty) {
      requiredFields.add('CPR');
    }
    if (_treatmentTypeController.text.isEmpty) {
      requiredFields.add('Treatment Type');
    }
    if (_notesController.text.isEmpty) {
      requiredFields.add('Notes');
    }
    if (requiredFields.isNotEmpty) {
      showErrorDialog(context,
          'Please fill in all required fields: ${requiredFields.join('\n')}');
      return;
    }

    String? uploadedImageUrl;
    if (_imageHandler.hasSelectedFile) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      uploadedImageUrl = await _imageHandler.uploadImageToFirebase(context);

      if (context.mounted) {
        Navigator.pop(context);
      }

      if (uploadedImageUrl == null) {
        showErrorDialog(context, 'Failed to upload image');
        return;
      }
    }

    String patientId;
    try {
      patientId = await fetchPatientId(_cprController.text);
    } catch (e) {
      showErrorDialog(context, 'Patient not found');
      return;
    }

    final treatmentData = TreatmentRecord(
      treatmentId: Data.generateRandomID().toString(),
      date: _dateController.text,
      time: _timeController.text,
      patientId: patientId,
      dentistId: Data.currentID!,
      cpr: _cprController.text,
      treatmentType: _treatmentTypeController.text,
      notes: _notesController.text,
      attachment: uploadedImageUrl,
    );

    await FirebaseFirestore.instance
        .collection('treatment')
        .add(treatmentData.toJson());

    if (context.mounted) {
      showMessagealert(context, 'Treatment Record Added Successfully');
      context.go('/treatment');
    }
  } catch (e) {
    showErrorDialog(context, 'Failed to add treatment record: $e');
  }
}
