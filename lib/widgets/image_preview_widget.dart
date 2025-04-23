import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

class ImagePreviewWidget extends StatelessWidget {
  final String? imageUrl;
  final html.File? imageFile;
  final double width;
  final double height;

  const ImagePreviewWidget({
    Key? key,
    this.imageUrl,
    this.imageFile,
    this.width = 200,
    this.height = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageId = 'image-${DateTime.now().millisecondsSinceEpoch}';
    // Register the view factory using the updated method
    ui_web.platformViewRegistry.registerViewFactory(imageId, (int viewId) {
      final imageElement = html.ImageElement()
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover';

      if (imageFile != null) {
        final blobUrl = html.Url.createObjectUrlFromBlob(imageFile!);
        imageElement.src = blobUrl;
      } else if (imageUrl != null) {
        imageElement.src = imageUrl!;
        // Add CORS headers
        imageElement.crossOrigin = 'anonymous';
      }

      return imageElement;
    });

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageFile != null || imageUrl != null
            ? HtmlElementView(viewType: imageId)
            : Center(
                child: Icon(Icons.image, color: Colors.grey),
              ),
      ),
    );
  }
}
