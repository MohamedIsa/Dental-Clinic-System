import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final Color overlayColor;

  const ServiceCard({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.overlayColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width <= 600;

    return Container(
      width: isMobile ? 120 : 150,
      height: isMobile ? 160 : 200,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: isMobile ? 40 : 60,
            height: isMobile ? 40 : 60,
          ),
          SizedBox(height: isMobile ? 30 : 50),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
