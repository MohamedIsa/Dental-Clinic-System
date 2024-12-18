import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/responsive_widget.dart';

class WelcomeHeader extends StatelessWidget implements PreferredSizeWidget {
  const WelcomeHeader({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return AppBar(
      title: Row(
        children: <Widget>[
          Image.asset(
            'assets/images/logoh.png',
            width: width * 0.09,
            height: height * 0.09,
          ),
          SizedBox(width: ResponsiveWidget.isLargeScreen(context) ? 800 : 40),
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
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
          },
        ),
      ],
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
