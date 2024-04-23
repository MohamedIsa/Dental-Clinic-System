import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WelcomePage extends StatelessWidget {
  Future<String> getFullName() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();
      String fullName = userDoc.get('FullName');
      List<String> names = fullName.split(' ');
      return names.first;
    }
    return 'User';
  }

  Future<List<DocumentSnapshot>> getBookings() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('userId', isEqualTo: user.uid)
          .get();
      return querySnapshot.docs;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
   double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            if (MediaQuery.of(context).size.width > 600)
              const SizedBox(width: 40),
            const Text(
              'Clinic',
              style: TextStyle(color: Colors.blue, fontSize: 20),
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
      drawer: MediaQuery.of(context).size.width <= 600
          ? Drawer(
              backgroundColor: Colors.blue,
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: const Text(
                      'Home',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text(
                      'Book Appointment',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/booking');
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Appointment History',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/appointmenthistory');
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Update Account',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text(
                      'edit Appointment',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            )
          : null,
      body: FutureBuilder<String>(
        future: getFullName(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
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
                  if (MediaQuery.of(context).size.width > 600)
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
                                onPressed: () {},
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
                        if (MediaQuery.of(context).size.width <= 600)
                          Container(
                            margin: const EdgeInsets.only(
                                top: 95, left: 20, right: 20),
                            padding: const EdgeInsets.all(10),
                            height: 130,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Welcome to our Dental Clinic\n ${snapshot.data} !',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        if (MediaQuery.of(context).size.width > 600)
                          Container(
                           margin: EdgeInsets.only(
                            top: 100,
                            left: screenWidth * 0.3,
                            right: screenWidth * 0.3),
                        padding: const EdgeInsets.all(20),
                            height: 130,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Welcome to our Dental Clinic\n ${snapshot.data} !',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
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
    );
  }
}



              /*
              FutureBuilder<List<DocumentSnapshot>>(
        future: getBookings(),
        builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Widget> bookingWidgets = [];
            if (snapshot.data!.isEmpty) {
              bookingWidgets.add(Text('No bookings found.'));
            } else {
              bookingWidgets.add(Text('Your Bookings:'));
              for (DocumentSnapshot booking in snapshot.data!) {
                bookingWidgets.add(Text('Dentist: ${booking['dentist']}, Time: ${booking['time']}'));
              }
            }
            return ListView(
              padding: EdgeInsets.all(16),
              children: bookingWidgets,
            );
          }
        },
      ),
    ],
  ),
        ),
      ),
    );
              */  
      
      
      
      
      
      
      
      
      
      
      
      
      
