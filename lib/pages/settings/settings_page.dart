import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final Function(String) navigateToSettings;

  const SettingsPage({super.key, required this.navigateToSettings});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Container(
        child: ListView(
          children: [
            _buildListTile(context, 'Staff Management'),
            _buildListTile(context, 'Dentist Color'),
            _buildListTile(context, 'Edit Message'),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, String title) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        tileColor: const Color.fromARGB(255, 38, 99, 148),
        onTap: () {
          navigateToSettings(title);
        },
      ),
    );
  }
}
