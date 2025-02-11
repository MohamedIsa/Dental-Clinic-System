import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

class FirebaseImageWidget extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;

  const FirebaseImageWidget({
    Key? key,
    required this.imageUrl,
    this.width = 200,
    this.height = 200,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageId = 'firebase-image-${DateTime.now().millisecondsSinceEpoch}';

    ui_web.platformViewRegistry.registerViewFactory(imageId, (int viewId) {
      final imageElement = html.ImageElement()
        ..src = imageUrl
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover';

      return imageElement;
    });

    return SizedBox(
      width: width,
      height: height,
      child: HtmlElementView(
        viewType: imageId,
      ),
    );
  }
}
