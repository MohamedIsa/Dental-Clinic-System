import 'package:flutter/material.dart';

class TopNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              _buildNavButton(context, 'Sign Up', () {
                Navigator.pushNamed(context, '/signup');
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
