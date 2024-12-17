import 'package:flutter/material.dart';

class TopNavigationBar extends StatelessWidget {
  const TopNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildNavButton(context, 'Home', () {}),
              _buildNavButton(context, 'Dental services', () {
                Navigator.pushNamed(context, '/service');
              }),
              _buildNavButton(context, 'About Us', () {
                Navigator.pushNamed(context, '/aboutus');
              }),
              _buildNavButton(context, 'Sign In', () {
                Navigator.pushNamed(context, '/login');
              }),
            ],
          ),
        ],
      ),
    );
  }

  TextButton _buildNavButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}
