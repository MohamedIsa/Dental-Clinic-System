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
                    Navigator.pushNamed(context, '/update');
                    break;
                  case 4:
                  Navigator.pushNamed(context, '/editappointment');
                    break;
                }
              },
            )
          : null,
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (ResponsiveWidget.isMediumScreen(context) ||
                ResponsiveWidget.isLargeScreen(context))
              Container(
                color: Colors.blue,
                height: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/dashboard');
                          },
                          child: const Text(
                            'Home',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/booking');
                          },
                          child: const Text(
                            'Book Appointment',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Appointment History',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/update');
                          },
                          child: const Text(
                            'Update Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Edit Appointment',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .where('uid',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final appointments = snapshot.data!.docs;
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final appointment = appointments[index];
final dentistId = appointment.exists ? appointment['did'] : '';
                        final timestamp = appointment['date'];
                        final time = appointment['hour'];
                        final date = DateTime.fromMillisecondsSinceEpoch(
                                timestamp.millisecondsSinceEpoch)
                            .toLocal();

                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('user')
                              .doc(dentistId)
                              .get(),
                          builder: (context, dentistSnapshot) {
                            if (dentistSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (dentistSnapshot.hasError) {
                              return Text('Error: ${dentistSnapshot.error}');
                            } else {
                              final dentistData = dentistSnapshot.data!;
                              final dentistFullName = dentistData['FullName'];
                              final firstName = dentistFullName
                                  .split(' ')[0]; // Extracting first name

                              if (ResponsiveWidget.isSmallScreen(context)) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue[400],
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(left:50),
                                    child: Text(
                                      'Dentist: Dr.$firstName \nDate: ${date.year}-${date.month}-${date.day} \nTime: $time:00',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.start,
                                    
                                    ),
                                  ),
                                );
                              } else if (ResponsiveWidget.isLargeScreen(
                                  context)||ResponsiveWidget.isMediumScreen(context)) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue[400],
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 250),
                                    child: Text(
                                      'Dentist: Dr.$firstName \nDate: ${date.year}-${date.month}-${date.day} \nTime: $time:00',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                );
                              }
                            }
                            return Container(); // Return a default container if none of the conditions are met
                          },
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
