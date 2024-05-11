import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  final String userName;

  const HeaderWidget({Key? key, required this.userName}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // Make the app bar transparent
      elevation: 0, // Remove the shadow
      automaticallyImplyLeading: false, // Don't show the back button
      title: Text('Welcome, $userName'), // Display welcome message with user name
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.grey,
              size: 25, // Adjust the size of the email icon
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
