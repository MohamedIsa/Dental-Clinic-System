import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:senior/const/app_colors.dart';

class MessageContainer extends StatelessWidget {
  final String? staticMessage;
  final Future<String>? futureMessage;
  final Widget? actionButton;
  final double? containerWidth;
  final double containerHeight;
  final EdgeInsetsGeometry margin;
  final bool isResponsive;
  final Color backgroundColor;

  const MessageContainer({
    super.key,
    this.staticMessage,
    this.futureMessage,
    this.actionButton,
    this.containerWidth,
    this.containerHeight = 200,
    this.margin = const EdgeInsets.only(top: 100),
    this.isResponsive = false,
    this.backgroundColor = AppColors.primaryColor,
  }) : assert(staticMessage != null || futureMessage != null,
            'Either staticMessage or futureMessage must be provided');

  Widget _buildMessageContent(BuildContext context, String message) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth <= 600;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 16 : 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        if (actionButton != null) actionButton!,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth <= 600;

    return Center(
      child: Container(
        margin: margin,
        padding: EdgeInsets.all(isMobile ? 10 : 20),
        height: containerHeight,
        width: containerWidth,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: futureMessage != null
            ? FutureBuilder<String>(
                future: futureMessage,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitFadingCircle(
                        color: Colors.white,
                        size: 20,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return _buildMessageContent(
                      context,
                      'Error loading message: ${snapshot.error}',
                    );
                  } else {
                    return _buildMessageContent(
                      context,
                      snapshot.data ?? 'No data available',
                    );
                  }
                },
              )
            : _buildMessageContent(context, staticMessage!),
      ),
    );
  }
}
