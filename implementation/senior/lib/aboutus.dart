import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senior/responsive_widget.dart';

class Aboutus extends StatefulWidget {
  const Aboutus({super.key});

  @override
  State<Aboutus> createState() => _AboutusState();
}

class _AboutusState extends State<Aboutus> {
  int _selectedIndex = 2;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            if (MediaQuery.of(context).size.width > 600)
              const SizedBox(width: 10),
            Image.asset(
              'assets/images/logoh.png',
              width: width * 0.09,
              height: height * 0.09,
            ),
           SizedBox(width: ResponsiveWidget.isLargeScreen(context) ? 400 : 40),
            Text(
            'About Us',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
          ],
          
        ),

        backgroundColor: Colors.transparent,
        elevation: 0,
        

      ),
      bottomNavigationBar: MediaQuery.of(context).size.width <= 600
          ? BottomNavigationBar(
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              unselectedLabelStyle: const TextStyle(color: Colors.grey),
              selectedLabelStyle: const TextStyle(color: Colors.blue),
              showUnselectedLabels: true,
              currentIndex: _selectedIndex,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.medical_services),
                  label: 'Dental Services',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.info),
                  label: 'About Us',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.login),
                  label: 'Sign In',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.app_registration),
                  label: 'Sign Up',
                ),
              ],
              onTap: (index) {
                setState(() {
                  index;
                });
                switch (index) {
                  case 0:
                    Navigator.pushNamed(
                      context,
                      '/home',
                    );
                    break;
                  case 1:
                    Navigator.pushNamed(
                      context,
                      '/service',
                    );
                    break;
                  case 2:
                    break;
                  case 3:
                    Navigator.pushNamed(
                      context,
                      '/login',
                    );
                    break;
                  case 4:
                    Navigator.pushNamed(
                      context,
                      '/signup',
                    );
                    break;
                }
              },
            )
          : null,
      body: Container(
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
                            onPressed: () {},
                            child: const Text(
                              'Dental services',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'About Us',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: const Text(
                              'Sign Up',
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
                  child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection('dentist').get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    final dentists = snapshot.data?.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: dentists?.length,
                      itemBuilder: (BuildContext context, int index) {
                        final dentist = dentists?[index];
                        final uid = dentist?.get('uid');
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('user')
                              .doc(uid)
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (snapshot.hasData) {
                              final user = snapshot.data;
                              final name = user?.get('FullName');
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                  color: Colors.blue[300],
                                ),
                                child: ListTile(
                                  title: Text('Dr.${name}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  subtitle: Text(
                                      'Welcome to Dr. ${name}, a dentist with expertise in creating radiant smiles. With personalized care, understanding each patients unique needs, ensuring comfort and confidence. Trust Dr. ${name} for a dental experience that combines expertise and empathy.',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                ),
                              );
                            }
                            return SizedBox.shrink();
                          },
                        );
                      },
                    );
                  }
                  return SizedBox.shrink();
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
