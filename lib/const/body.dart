import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  final List<Widget> children;

  const Body({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1150,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/Background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          ...children,
        ],
      ),
    );
  }
}
