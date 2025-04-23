import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:senior/utils/popups.dart';

class ImageHandler {
  html.File? _selectedFile;

  bool get hasSelectedFile => _selectedFile != null;
  html.File? get selectedFile => _selectedFile;
  set selectedFile(html.File? file) => _selectedFile = file;

  Future<html.File?> pickImage(BuildContext context) async {
    final input = html.FileUploadInputElement()
      ..accept = 'image/*'
      ..click();

    await input.onChange.first;

    if (input.files?.isNotEmpty ?? false) {
      _selectedFile = input.files![0];
      return _selectedFile;
    }

    return null;
  }

  void removeImage() {
    _selectedFile = null;
  }

  Future<String?> uploadImageToFirebase(BuildContext context) async {
    if (_selectedFile == null) return null;

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = _selectedFile!.name.split('.').last;
      String fileName = 'treatments/image_$timestamp.$extension';

      // Create storage reference
      final ref = FirebaseStorage.instance.ref().child(fileName);

      // Create metadata with CORS settings
      final metadata = SettableMetadata(
        contentType: _selectedFile!.type,
        customMetadata: {
          'uploaded_by': 'web_app',
          'timestamp': timestamp.toString(),
          'original_name': _selectedFile!.name,
        },
      );

      // Upload as blob
      final uploadTask = ref.putBlob(
        _selectedFile!,
        metadata,
      );

      // Wait for upload to complete
      await uploadTask;

      // Get download URL
      final downloadUrl = await ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      showErrorDialog(context, 'Failed to upload image: $e');
      return null;
    }
  }
}
