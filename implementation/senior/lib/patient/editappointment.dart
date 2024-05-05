import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:senior/responsive_widget.dart';

class Editappointment extends StatefulWidget {
  const Editappointment({Key? key}) : super(key: key);

  @override
  State<Editappointment> createState() => _EditappointmentState();
}

class _EditappointmentState extends State<Editappointment> {
  int _selectedIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Appointment'),
      ),
      bottomNavigationBar: ResponsiveWidget.isSmallScreen(context)
          ? BottomNavigationBar(
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              unselectedLabelStyle: const TextStyle(color: Colors.grey),
              selectedLabelStyle: const TextStyle(color: Colors.blue),
              showUnselectedLabels: true,
              currentIndex: _selectedIndex,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: const Icon(
                    Icons.home,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(
                    Icons.calendar_today,
                  ),
                  label: 'Book Appointment',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(
                    Icons.history,
                  ),
                  label: 'Appointment History',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(
                    Icons.person,
                  ),
                  label: 'Update Account',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(
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
                    Navigator.pushNamed(context, '/appointmenthistory');
                    break;
                  case 3:
                    Navigator.pushNamed(context, '/update');
                    break;
                  case 4:
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
                          onPressed: () {
                            Navigator.pushNamed(context, '/appointmenthistory');
                          },
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
                        final dentistId = appointment['did'];
                        final timestamp = appointment['date'];
                        final time = appointment['hour'];
                        final appointmentDateTime =
                            DateTime.fromMillisecondsSinceEpoch(
                                    timestamp.millisecondsSinceEpoch)
                                .toLocal();
                        final currentDateTime = DateTime.now();
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('user')
                              .doc(dentistId)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasData) {
                              if (!snapshot.data!.exists) {
                                return const Text('Dentist not found');
                              } else {
                                final dentist = snapshot.data!;
                                final dentistName = dentist['FullName'];
                                final firstName = dentistName.split(' ')[0];

                                if ((appointmentDateTime
                                        .isAfter(currentDateTime) &&
                                    (ResponsiveWidget.isLargeScreen(context) ||
                                        ResponsiveWidget.isMediumScreen(
                                            context)))) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue[400],
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 250.0),
                                          child: Text(
                                            'Appointment with Dr. $firstName\nDate: ${appointmentDateTime.year}-${appointmentDateTime.month}-${appointmentDateTime.day} \nTime: $time:00',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(left: 600),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    '/updateappointment',
                                                    arguments: appointment.id,
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Delete Appointment'),
                                                        content: const Text(
                                                            'Are you sure you want to delete this appointment?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              try {
                                                                // Delete logic here
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'appointments')
                                                                    .doc(appointment
                                                                        .id) // Assuming appointment.id is the document ID of the appointment
                                                                    .delete();
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              } catch (e) {
                                                                print(
                                                                    'Error deleting appointment: $e');
                                                                // You can display an error message here if needed
                                                              }
                                                            },
                                                            child: const Text(
                                                                'Yes'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                'No'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (ResponsiveWidget.isSmallScreen(
                                        context) ||
                                    appointmentDateTime
                                        .isAfter(currentDateTime)) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue[400],
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 50.0),
                                          child: Text(
                                            'Appointment with Dr. $firstName\nDate: ${appointmentDateTime.year}-${appointmentDateTime.month}-${appointmentDateTime.day} \nTime: $time:00',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(left: 50),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                  size: 12.0,
                                                ),
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    '/updateappointment',
                                                    arguments: appointment.id,
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.white,
                                                    size: 12.0),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Delete Appointment'),
                                                        content: const Text(
                                                            'Are you sure you want to delete this appointment?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              try {
                                                                // Delete logic here
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'appointments')
                                                                    .doc(appointment
                                                                        .id) 
                                                                    .delete();
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              } catch (e) {
                                                                print(
                                                                    'Error deleting appointment: $e');
                                                                // You can display an error message here if needed
                                                              }
                                                            },
                                                            child: const Text(
                                                                'Yes'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                'No'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return const SizedBox
                                      .shrink(); // Hide passed appointments and large/medium screen with past appointments
                                }
                              }
                            }
                            return const CircularProgressIndicator();
                          },
                        );
                      },
                    ),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
