import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../../utils/responsive_widget.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int _selectedIndex = 0;
  Future<List<String>> getAllAdminUIDs() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('admin').get();

      List<String> adminUIDs = querySnapshot.docs.map((doc) => doc.id).toList();
      return adminUIDs;
    } catch (e) {
      print('Error retrieving admin UIDs: $e');
      return []; // Return an empty list if there's an error
    }
  }

  Future<String> getFullName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      String fullName = userDoc.get('name');
      List<String> names = fullName.split(' ');
      return names.first;
    }
    return 'User';
  }

  Future<String> getUpcomingAppointment(String uid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('uid', isEqualTo: uid)
        .orderBy('date')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DateTime now = DateTime.now();
      // Define the start and end hours for appointments
      int startHour = 9;
      int endHour = 17;

      for (DocumentSnapshot appointment in querySnapshot.docs) {
        DateTime appointmentDate =
            (appointment.get('date') as Timestamp).toDate();

        dynamic hourValue = appointment['hour'];
        int appointmentHour;
        if (hourValue is int) {
          appointmentHour = hourValue;
        } else if (hourValue is String) {
          appointmentHour = int.parse(hourValue);
        } else {
          // Handle the case where hourValue is neither int nor String
          appointmentHour = 0; // or any default value you prefer
        }

        // Calculate the appointment time in DateTime format
        DateTime appointmentTime = DateTime(
          appointmentDate.year,
          appointmentDate.month,
          appointmentDate.day,
          appointmentHour,
        );

        // Check if the appointment is within the working hours and after the current time
        if (appointmentHour >= startHour &&
            appointmentHour <= endHour &&
            appointmentTime.isAfter(now)) {
          // Retrieve appointment data
          String dentistId = appointment['did'] ?? '';
          DocumentSnapshot dentistDoc = await FirebaseFirestore.instance
              .collection('user')
              .doc(dentistId)
              .get();
          String dentist = dentistDoc.get('FullName') ?? '';
          String dentistfirst = dentist.split(' ').first;
          String formattedDate =
              DateFormat('yyyy-MM-dd').format(appointmentDate);
          String formattedAppointment =
              '\nDate: $formattedDate\nDentist: Dr.$dentistfirst,\nTime: ${appointmentHour.toString()}:00';

          return formattedAppointment;
        }
      }
    }

    return 'No upcoming appointments';
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ResponsiveWidget(
      largeScreen: Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Image.asset(
                'assets/images/logoh.png',
                width: width * 0.09,
                height: height * 0.09,
              ),
              SizedBox(
                  width: ResponsiveWidget.isLargeScreen(context) ? 800 : 40),
              FutureBuilder<String>(
                future: getFullName(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Text(
                      'Welcome, ${snapshot.data}!',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, '/home');
              },
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0.0,
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
                      Navigator.pushNamed(context, '/editappointment');
                      break;
                  }
                },
              )
            : null,
        body: FutureBuilder<String>(
          future: getFullName(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SpinKitFadingCube(
                  color: Colors.blue,
                  size: 50.0,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return Container(
              height: MediaQuery.of(context).size.height * 1.5,
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    if (ResponsiveWidget.isMediumScreen(context) ||
                        ResponsiveWidget.isLargeScreen(context))
                      Container(
                        height: 40,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                TextButton(
                                  onPressed: () {},
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
                                    Navigator.pushNamed(
                                        context, '/appointmenthistory');
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
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/editappointment');
                                  },
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
                    Container(
                      width: double.infinity,
                      height: 1150,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/Background.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: ResponsiveWidget.isLargeScreen(context)
                                    ? 80
                                    : 0),
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: 80,
                                  left: ResponsiveWidget.isLargeScreen(context)
                                      ? 300
                                      : 20,
                                  right: ResponsiveWidget.isLargeScreen(context)
                                      ? 300
                                      : 20),
                              padding: const EdgeInsets.all(20),
                              height: 200,
                              width: 400,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FutureBuilder<String>(
                                    future: getUpcomingAppointment(
                                        FirebaseAuth.instance.currentUser!.uid),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return SpinKitFadingCircle(
                                          color: Colors.white,
                                          size: 20,
                                        );
                                      } else if (snapshot.hasError) {
                                        print('Error: ${snapshot.error}');
                                        return Text(
                                          'Error loading appointment',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        );
                                      } else {
                                        return Text(
                                          'Upcoming Appointment: ${snapshot.data}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                ResponsiveWidget.isLargeScreen(
                                                        context)
                                                    ? 20
                                                    : 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {},
          child: const Icon(Icons.chat),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}
