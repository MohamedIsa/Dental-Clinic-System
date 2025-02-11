import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/popups.dart';
import 'image_handler.dart';

Future<void> updateTreatment({
  required String treatmentId,
  required Map<String, dynamic> updatedTreatmentData,
  required BuildContext context,
  required ImageHandler imageHandler,
  required String? currentAttachment,
}) async {
  try {
    String? newAttachmentUrl;
    if (imageHandler.hasSelectedFile) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      newAttachmentUrl = await imageHandler.uploadImageToFirebase(context);

      if (!context.mounted) return;
      Navigator.pop(context); // Remove loading indicator

      if (newAttachmentUrl == null) {
        showErrorDialog(context, 'Failed to upload new image');
        return;
      }
    }

    final treatmentData = {
      ...updatedTreatmentData,
      'attachment': newAttachmentUrl ?? currentAttachment,
    };

    await FirebaseFirestore.instance
        .collection('treatment')
        .doc(treatmentId)
        .update(treatmentData);

    if (!context.mounted) return;
    showMessagealert(context, 'Treatment Record Updated Successfully');
    Navigator.pop(context);
  } catch (e) {
    if (!context.mounted) return;
    showErrorDialog(context, 'Error updating treatment: $e');
  }
}
