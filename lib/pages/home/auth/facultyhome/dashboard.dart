import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../../../utils/responsive_widget.dart';
import 'dentistlist.dart';
import '../../../../providers/side_menu_provider.dart';
import 'side_menu_widget.dart';
import 'header_widget.dart';
import 'today_appointment.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key});

  @override
  Widget build(BuildContext context) {
    final sideMenuProvider =
        Provider.of<SideMenuProvider>(context, listen: false);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    String role = '';
    FirebaseFirestore.instance.collection('users').doc(uid).get().then((doc) {
      if (doc.exists) {
        role = doc.data()?['role'] ?? '';
      }
    });

    bool isWeb = kIsWeb && ResponsiveWidget.isLargeScreen(context);

    return FutureBuilder(
      future: sideMenuProvider.loadMenu(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitFadingCube(
            size: 30,
            color: Colors.blue,
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          return isWeb
              ? StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final fullName = snapshot.data?.get('name') ?? '';
                      final firstName = fullName.split(' ')[0];

                      return Scaffold(
                        appBar: HeaderWidget(userName: firstName),
                        body: SafeArea(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 7,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: SideMenuWidget(),
                                    ),
                                    Expanded(
                                      flex: 10,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            right: BorderSide(
                                              color: Colors.grey,
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                        child: role == 'admin' ||
                                                role == 'recptionist'
                                            ? TodayAppointmentPage()
                                            : null,
                                      ),
                                    ),
                                    //===========================================================
                                    //admin recptionist
                                    role == 'admin' || role == 'recptionist'
                                        ? Expanded(
                                            flex: 5,
                                            child: DentistsDataTable(),
                                          )
                                        : Container(),
                                    //=================================================
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return SpinKitFadingCube(
                        size: 30,
                        color: Colors.blue,
                      );
                    }
                  },
                )
              : Scaffold(
                  appBar: AppBar(
                    title: Text('Mobile View',
                        style: TextStyle(color: Colors.red)),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                      ),
                    ],
                  ),
                  body: Center(
                    child: Text(
                      'You cannot use this page unless you are on the web.',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
        }
      },
    );
  }
}
