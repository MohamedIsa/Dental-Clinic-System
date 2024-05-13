import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  final String userName;

  const HeaderWidget({Key? key, required this.userName}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue, // Set the background color to blue
      ),
      child: AppBar(
        backgroundColor: Colors.transparent, // Make the app bar transparent
        elevation: 0, // Remove the shadow
        automaticallyImplyLeading: false, // Don't show the back button
        title: Text(
          'Welcome, Dr. $userName',
          style: TextStyle(color: Colors.white), // Set text color to white
        ), // Display welcome message with user name
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.white, // Set icon color to white
                size: 25, // Adjust the size of the email icon
              ),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, '/home');
              },
            ),
          ),
        ],
      ),
    );
  }
}