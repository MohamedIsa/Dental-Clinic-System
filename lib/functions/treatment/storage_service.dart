import 'dart:html' as html;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../utils/popups.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadTreatmentImage(
      BuildContext context, html.File file) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = file.type.split('/').last;
      String fileName = 'treatments/image_$timestamp.$extension';

      // Create storage reference
      final ref = _storage.ref().child(fileName);

      // Create metadata with CORS settings
      final metadata = SettableMetadata(
        contentType: file.type,
        customMetadata: {
          'uploaded_by': 'web_app',
          'timestamp': timestamp.toString(),
          'original_name': file.name,
        },
      );

      // Upload as blob
      final uploadTask = ref.putBlob(file, metadata);

      // Wait for upload to complete
      await uploadTask;

      // Get download URL with CORS headers
      final downloadUrl = await ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      showErrorDialog(context, 'Failed to upload image: $e');
      return null;
    }
  }
}
