import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text('General Settings'),
              onTap: () {
                // Handle general settings onTap action
                // Navigate to the general settings page
              },
            ),
            ListTile(
              title: Text('Appointment Settings'),
              onTap: () {
                // Handle appointment settings onTap action
                // Navigate to the appointment settings page
              },
            ),
            ListTile(
              title: Text('Staff Management'),
              onTap: () {
                // Handle staff management onTap action
                // Navigate to the staff management page
              },
            ),
            ListTile(
              title: Text('Notifications and Alerts'),
              onTap: () {
                // Handle notifications and alerts onTap action
                // Navigate to the notifications and alerts page
              },
            ),
            ListTile(
              title: Text('Edit Coupon'),
              onTap: () {
                // Handle edit coupon onTap action
                // Navigate to the edit coupon page
              },
            ),
          ],
        ),
      ),
    );
  }
}