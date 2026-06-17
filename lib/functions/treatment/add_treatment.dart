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
  TextEditingController cprController,
  TextEditingController treatmentTypeController,
  TextEditingController notesController,
  ImageHandler imageHandler,
  TextEditingController dateController,
  TextEditingController timeController,
) async {
  try {
    List<String> requiredFields = [];

    if (cprController.text.isEmpty) {
      requiredFields.add('CPR');
    }
    if (treatmentTypeController.text.isEmpty) {
      requiredFields.add('Treatment Type');
    }
    if (notesController.text.isEmpty) {
      requiredFields.add('Notes');
    }
    if (requiredFields.isNotEmpty) {
      showErrorDialog(
        context,
        'Please fill in all required fields: ${requiredFields.join('\n')}',
      );
      return;
    }

    String? uploadedImageUrl;
    if (imageHandler.hasSelectedFile) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      uploadedImageUrl = await imageHandler.uploadImageToFirebase(context);

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
      patientId = await fetchPatientId(cprController.text);
    } catch (e) {
      showErrorDialog(context, 'Patient not found');
      return;
    }

    final treatmentData = TreatmentRecord(
      treatmentId: Data.generateRandomID().toString(),
      date: dateController.text,
      time: timeController.text,
      patientId: patientId,
      dentistId: Data.currentID!,
      cpr: cprController.text,
      treatmentType: treatmentTypeController.text,
      notes: notesController.text,
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
