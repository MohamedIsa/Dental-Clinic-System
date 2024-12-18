import 'package:flutter/material.dart';

class WelcomeSection extends StatelessWidget {
  final String welcomeMessage;
  final double screenWidth;

  const WelcomeSection(
      {super.key, required this.welcomeMessage, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return screenWidth <= 600
        ? _buildMobileWelcomeSection(context)
        : _buildDesktopWelcomeSection(context);
  }

  Widget _buildMobileWelcomeSection(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 100, bottom: 900),
        padding: const EdgeInsets.all(10),
        height: 130,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              welcomeMessage,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            _buildSignUpButton(context, fontSize: 16, borderRadius: 16.0),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopWelcomeSection(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 100, bottom: 800),
        padding: const EdgeInsets.all(20),
        height: 200,
        width: 430,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              welcomeMessage,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildSignUpButton(context, fontSize: 20, borderRadius: 32.0),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context,
      {required double fontSize, required double borderRadius}) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, "/signup");
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 249, 179, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        elevation: 5,
      ),
      child: Text(
        'Sign Up',
        style: TextStyle(color: Colors.white, fontSize: fontSize),
      ),
    );
  }
}
