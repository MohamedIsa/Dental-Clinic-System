import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import '../../../utils/responsive_widget.dart';

class WelcomeContent extends StatelessWidget {
  const WelcomeContent({Key? key}) : super(key: key);

  Future<String> getUpcomingAppointment(String uid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('uid', isEqualTo: uid)
        .orderBy('date')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DateTime now = DateTime.now();
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
          appointmentHour = 0;
        }

        DateTime appointmentTime = DateTime(
          appointmentDate.year,
          appointmentDate.month,
          appointmentDate.day,
          appointmentHour,
        );

        if (appointmentHour >= startHour &&
            appointmentHour <= endHour &&
            appointmentTime.isAfter(now)) {
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
    return FutureBuilder<String>(
      future: getUpcomingAppointment(FirebaseAuth.instance.currentUser!.uid),
      builder: (context, snapshot) {
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }
}
