import 'package:flutter/material.dart';
import 'package:senior/service_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
        if (MediaQuery.of(context).size.width > 600) 
        SizedBox(width: 40),
        Text( 'Top Navigation Bar',style: TextStyle(color: Colors.blue, fontSize: 20),),
        ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,

      ),
      drawer: MediaQuery.of(context).size.width <= 600 ? Drawer(
        child: ListView(
          children: <Widget>[
        ListTile(
          title: const Text('Dental Services', style: TextStyle(color:Colors.white ),),
          onTap: () {},
        ),
        ListTile(
          title: const Text('Book Appointment', style: TextStyle(color:Colors.white ),),
          onTap: () {},
        ),
        ListTile(
          title: const Text('About Us', style: TextStyle(color:Colors.white ),),
          onTap: () {},
        ),
        ListTile(
          title: const Text('Sign In', style: TextStyle(color:Colors.white ),),
          onTap: () {},
        ),
          ],
        ),
        backgroundColor: Colors.blue,
      )
      :null,
      body: Container(
        height: MediaQuery.of(context).size.height*1.5,
        decoration: BoxDecoration(
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
                            child: Text(
                              'Menu',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Dental services',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Book Appointment',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'About Us',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Sign In',
                              style: TextStyle(color: Colors.white),
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
                decoration: BoxDecoration(
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
                        margin: EdgeInsets.only(top: 95, left: 20, right: 20),
                        padding: EdgeInsets.all(10),
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Welcome to our Dental Clinic\nSign up now to get 20% off on your first visit',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 249, 179, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        color: Colors.blue,
                      ),
                    if (MediaQuery.of(context).size.width > 600)
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 95, left: 440),
                        padding: EdgeInsets.all(20),
                        height: MediaQuery.of(context).size.width <= 600
                            ? 300
                            : 200,
                        width: 450,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Welcome to our Dental Clinic\nSign up now to get 20% off on your first visit',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 249, 179, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        color: Colors.blue,
                      ),
                        if (MediaQuery.of(context).size.width > 600)
                    Container(
                      margin: EdgeInsets.only(top: 500),
                      child: Column(
                        children: [
                          Text('Our Services',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 50)),
                          SizedBox(height: 90),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ServiceCard(
                                  title: 'Dental Implants',
                                  imagePath: 'assets/cards/implant.png',
                                  overlayColor: Colors.white),
                              ServiceCard(
                                  title: 'Orthodontics',
                                  imagePath: 'assets/cards/Orthodontics.png',
                                  overlayColor: Colors.white),
                              ServiceCard(
                                  title: 'Laser Dentistry',
                                  imagePath: 'assets/cards/laser-beam.png',
                                  overlayColor: Colors.white),
                              ServiceCard(
                                  title: 'Teeth Whitening',
                                  imagePath: 'assets/cards/whiteing.png',
                                  overlayColor: Colors.white),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ServiceCard(
                                  title: 'Root Canal',
                                  imagePath: 'assets/cards/root-canal.png',
                                  overlayColor: Colors.white),
                              ServiceCard(
                                  title: 'Gum Depigmentation',
                                  imagePath: 'assets/cards/gum.png',
                                  overlayColor: Colors.white),
                              ServiceCard(
                                  title: 'Dental Fillings',
                                  imagePath: 'assets/cards/tooth-filling.png',
                                  overlayColor: Colors.white),
                              ServiceCard(
                                  title: 'Crowns & Bridges',
                                  imagePath: 'assets/cards/bridge.png',
                                  overlayColor: Colors.white),
                            ],
                          ),
                        ],
                      ),
                    ),
                  
                  if (MediaQuery.of(context).size.width <= 600)
                          Container(
                            margin: EdgeInsets.only(top: 370),
                            child: Column(
                              children: [
                                Text('Our Services',
                                    style: TextStyle(color: Colors.white, fontSize: 20)),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ServiceCard(
                                        title: 'Dental Implants',
                                        imagePath: 'assets/cards/implant.png',
                                        overlayColor: Colors.white),
                                    ServiceCard(
                                        title: 'Orthodontics',
                                        imagePath: 'assets/cards/Orthodontics.png',
                                        overlayColor: Colors.white),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ServiceCard(
                                        title: 'Laser Dentistry',
                                        imagePath: 'assets/cards/laser-beam.png',
                                        overlayColor: Colors.white),
                                    ServiceCard(
                                        title: 'Teeth Whitening',
                                        imagePath: 'assets/cards/whiteing.png',
                                        overlayColor: Colors.white),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ServiceCard(
                                        title: 'Root Canal',
                                        imagePath: 'assets/cards/root-canal.png',
                                        overlayColor: Colors.white),
                                    ServiceCard(
                                        title: 'Gum Depigmentation',
                                        imagePath: 'assets/cards/gum.png',
                                        overlayColor: Colors.white),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ServiceCard(
                                        title: 'Dental Fillings',
                                        imagePath: 'assets/cards/tooth-filling.png',
                                        overlayColor: Colors.white),
                                    ServiceCard(
                                        title: 'Crowns & Bridges',
                                        imagePath: 'assets/cards/bridge.png',
                                        overlayColor: Colors.white),
                                  ],
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
                     
              if (MediaQuery.of(context).size.width > 600)
                Container(
                  height: 200,
                  color: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Follow Us on Social Media',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                      SizedBox(height: 60),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            'assets/social media/facebook.png',
                            width: 50,
                            height: 50,
                          ),
                          Image.asset(
                            'assets/social media/linkedin.png',
                            width: 50,
                            height: 50,
                          ),
                          Image.asset(
                            'assets/social media/instagram.png',
                            width: 50,
                            height: 50,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (MediaQuery.of(context).size.width <= 600)
                Container(
                  height: 200,
                  color: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Follow Us on Social Media',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(height: 60),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            'assets/social media/facebook.png',
                            width: 50,
                            height: 50,
                          ),
                          Image.asset(
                            'assets/social media/linkedin.png',
                            width: 50,
                            height: 50,
                          ),
                          Image.asset(
                            'assets/social media/instagram.png',
                            width: 50,
                            height: 50,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
