import 'package:flutter/material.dart';
import '../../../const/messagecontainer.dart';
import '../../../functions/home/welcomemessage.dart';

class WelcomeSection extends StatelessWidget {
  final double screenWidth;

  const WelcomeSection({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;
    return MessageContainer(
      futureMessage: fetchWelcomeMessage(),
      containerWidth: isMobile ? null : 430,
      containerHeight: isMobile ? 130 : 200,
      margin: const EdgeInsets.only(top: 100, bottom: 800),
      actionButton: _buildSignUpButton(
        context,
        fontSize: isMobile ? 16 : 20,
        borderRadius: isMobile ? 16.0 : 32.0,
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
