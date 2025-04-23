import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../functions/treatment/image_handler.dart';
import '../../../widgets/image_preview_widget.dart';
import '../../../widgets/firebase_image_widget.dart';

class TreatmentFormHeader extends StatelessWidget {
  final String title;

  const TreatmentFormHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade700,
      ),
    );
  }
}

class TreatmentTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool required;
  final int maxLines;
  final bool isCpr;
  final bool readOnly;

  const TreatmentTextField({
    super.key,
    required this.controller,
    required this.label,
    this.required = false,
    this.maxLines = 1,
    this.isCpr = false,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      keyboardType: isCpr ? TextInputType.number : TextInputType.text,
      maxLength: isCpr ? 9 : null,
      inputFormatters: isCpr
          ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(9),
            ]
          : null,
      decoration: InputDecoration(
        labelText: label + (required ? ' *' : ''),
        labelStyle: TextStyle(color: Colors.blue.shade700),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade500, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        counterText: isCpr ? '' : null,
      ),
    );
  }
}

class TreatmentAttachmentSection extends StatelessWidget {
  final ImageHandler imageHandler;
  final String? currentAttachment;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;

  const TreatmentAttachmentSection({
    super.key,
    required this.imageHandler,
    this.currentAttachment,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attachments',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue.shade200),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            children: [
              if (imageHandler.hasSelectedFile)
                ImagePreviewWidget(
                  imageFile: imageHandler.selectedFile,
                  width: 200,
                  height: 200,
                )
              else if (currentAttachment != null)
                FirebaseImageWidget(
                  imageUrl: currentAttachment!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(
                      imageHandler.hasSelectedFile || currentAttachment != null
                          ? Icons.edit
                          : Icons.attach_file,
                      color: Colors.white,
                    ),
                    label: Text(
                      imageHandler.hasSelectedFile || currentAttachment != null
                          ? 'Change Image'
                          : 'Add Image',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade500,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: onPickImage,
                  ),
                  if (imageHandler.hasSelectedFile ||
                      currentAttachment != null) ...[
                    SizedBox(width: 8),
                    TextButton.icon(
                      icon: Icon(Icons.delete, color: Colors.red.shade400),
                      label: Text(
                        'Remove',
                        style: TextStyle(color: Colors.red.shade400),
                      ),
                      onPressed: onRemoveImage,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
