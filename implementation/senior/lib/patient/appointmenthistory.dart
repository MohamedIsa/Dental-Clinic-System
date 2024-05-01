import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:senior/responsive_widget.dart';

class AppointmentHistoryPage extends StatefulWidget {
  @override
  State<AppointmentHistoryPage> createState() => _AppointmentHistoryPageState();
}

class _AppointmentHistoryPageState extends State<AppointmentHistoryPage> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment History'),
      ),
      bottomNavigationBar: ResponsiveWidget.isSmallScreen(context)
          ? BottomNavigationBar(
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              unselectedLabelStyle: TextStyle(color: Colors.grey),
              selectedLabelStyle: TextStyle(color: Colors.blue),
              showUnselectedLabels: true,
              currentIndex: _selectedIndex,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.calendar_today,
                  ),
                  label: 'Book Appointment',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.history,
                  ),
                  label: 'Appointment History',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  label: 'Update Account',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.edit,
                  ),
                  label: 'Edit Appointment',
                ),
              ],
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                switch (index) {
                  case 0:
                    Navigator.pushNamed(context, '/dashboard');
                    break;
                  case 1:
                    Navigator.pushNamed(context, '/bookingm');
                    break;
                  case 2:
                    break;
                  case 3:
                    // Handle Update Account navigation
                    break;
                  case 4:
                    // Handle Edit Appointment navigation
                    break;
                }
              },
            )
          : null,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final appointments = snapshot.data!.docs;
            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                final dentist = appointment['dentist'];
                final timestamp = appointment['date'];
                final time = appointment['hour'];
                final date = DateTime.fromMillisecondsSinceEpoch(
                        timestamp.millisecondsSinceEpoch)
                    .toLocal();
                if (ResponsiveWidget.isSmallScreen(context)) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue[400],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                        'Dentist: $dentist \nDate: ${date.year}-${date.month}-${date.day} \nTime: $time:00',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ), 
                  );
                }
                if (ResponsiveWidget.isLargeScreen(context)) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue[400],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                        'Dentist: $dentist \nDate: ${date.year}-${date.month}-${date.day} \nTime: $time:00',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ), 
                  );
                }
                return null;
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
