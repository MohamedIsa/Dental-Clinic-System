import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senior/service_card.dart';
import 'package:senior/registration/signup_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String welcomeMessage = '';
  @override
  void initState() {
    super.initState();
    fetchWelcomeMessage();
  }

  Future<void> fetchWelcomeMessage() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('welcome').limit(1).get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          welcomeMessage = snapshot.docs.first['message'];
        });
      }
    } catch (error) {
      print('Error fetching welcome message: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
                switch (index) {
                  case 0:
                    break;
                  case 1:
                  Navigator.pushNamed(context, '/service');
                    break;
                  case 2:
                    Navigator.pushNamed(context, '/aboutus');
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
                            onPressed: () {
                              Navigator.pushNamed(context, '/service');
                            },
                            child: const Text(
                              'Dental services',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/aboutus');
                            },
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
                        margin: const EdgeInsets.only(left: 70, top: 100),
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
                              welcomeMessage,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignUp()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 249, 179, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
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
                        height: MediaQuery.of(context).size.width <= 600
                            ? 300
                            : 200,
                        width: 430,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              welcomeMessage,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignUp()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 249, 179, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (MediaQuery.of(context).size.width > 600)
                      Center(
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.blue, width: 2),
                              bottom: BorderSide(color: Colors.blue, width: 2),
                              left: BorderSide(color: Colors.blue, width: 2),
                              right: BorderSide(color: Colors.blue, width: 2),
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                          ),
                          margin: const EdgeInsets.only(top: 300),
                          child: const Column(
                            children: [
                              const Text('Our Services',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 30)),
                              SizedBox(height: 90),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ServiceCard(
                                      title: 'Dental Implants',
                                      imagePath: 'assets/cards/implant.png',
                                      description:
                                          'Dental implants are titanium tooth roots placed into the jawbone to support replacement teeth. They offer a durable and natural-looking solution for missing teeth, enhancing chewing, speech, and overall oral health'),
                                  ServiceCard(
                                    title: 'Orthodontics',
                                    imagePath: 'assets/cards/braces.png',
                                    description:
                                        'Orthodontics is a dental specialty aimed at correcting misaligned teeth and jaws for improved oral health and aesthetics. Treatments involve braces or aligners to gradually align teeth and address issues like overcrowding and bite problems, enhancing both appearance and function',
                                  ),
                                  ServiceCard(
                                    title: 'Laser Dentistry',
                                    imagePath: 'assets/cards/laser-beam.png',
                                    description:
                                        'Laser dentistry utilizes laser technology for precise and minimally invasive dental procedures, offering benefits like reduced discomfort, faster healing, and greater precision compared to traditional methods. It encompasses treatments for gum disease, cavity preparation, tooth whitening, and soft tissue procedures, providing patients with a more comfortable and efficient dental experience.',
                                  ),
                                  ServiceCard(
                                    title: 'Teeth Whitening',
                                    imagePath: 'assets/cards/healthy-tooth.png',
                                    description:
                                        'Teeth whitening is a cosmetic dental procedure that aims to lighten teeth and remove stains. It can be done using bleaching agents like hydrogen peroxide. This safe and effective treatment enhances smile appearance, though results may vary based on staining severity and oral health.',
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ServiceCard(
                                    title: 'Root Canal',
                                    imagePath: 'assets/cards/root-canal.png',
                                    description:
                                        'A root canal is a dental procedure that addresses infected or damaged tooth pulp by removing the affected tissue, cleaning the inside of the tooth, and sealing it to prevent further infection. This treatment alleviates pain, preserves the tooth, and restores its function, often followed by the placement of a crown for added protection and strength.',
                                  ),
                                  ServiceCard(
                                    title: 'Gum Depigmentation',
                                    imagePath: 'assets/cards/infection.png',
                                    description:
                                        'Gum depigmentation is a cosmetic dental procedure that reduces dark spots on the gums caused by excess melanin pigmentation. It involves techniques like laser treatment or surgical scraping to remove pigmented tissue, revealing lighter-colored gums underneath. This procedure improves smile aesthetics and is safe and effective for achieving a more uniform gum line.',
                                  ),
                                  ServiceCard(
                                    title: 'Dental Fillings',
                                    imagePath: 'assets/cards/tooth-filling.png',
                                    description:
                                        'Dental fillings are materials used to repair teeth damaged by decay, fractures, or wear. Dentists remove the damaged portion of the tooth and fill the space with materials like amalgam or composite resin to restore its strength and function. Fillings prevent further decay, restore appearance, and aid in chewing.',
                                  ),
                                  ServiceCard(
                                    title: 'Crowns & Bridges',
                                    imagePath: 'assets/cards/bridge.png',
                                    description:
                                        'Crowns are covers used to repair damaged teeth, while bridges replace missing teeth by bridging the gap between adjacent teeth. Crowns restore the shape, strength, and appearance of a tooth, while bridges restore chewing function and maintain tooth alignment. Both are custom-made restorations that provide long-lasting solutions for dental issues.',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          height: 520,
                          width: 1000,
                        ),
                      ),
                    if (MediaQuery.of(context).size.width <= 600)
                      Center(
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.blue, width: 2),
                              bottom: BorderSide(color: Colors.blue, width: 2),
                              left: BorderSide(color: Colors.blue, width: 2),
                              right: BorderSide(color: Colors.blue, width: 2),
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                          ),
                          margin: const EdgeInsets.only(top: 350),
                          child: const Column(
                            children: [
                              Text(
                                'Our Services',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ServiceCard(
                                      title: 'Dental Implants',
                                      imagePath: 'assets/cards/implant.png',
                                      description:
                                          'Dental implants are titanium tooth roots placed into the jawbone to support replacement teeth. They offer a durable and natural-looking solution for missing teeth, enhancing chewing, speech, and overall oral health'),
                                  ServiceCard(
                                    title: 'Orthodontics',
                                    imagePath: 'assets/cards/braces.png',
                                    description:
                                        'Orthodontics is a dental specialty aimed at correcting misaligned teeth and jaws for improved oral health and aesthetics. Treatments involve braces or aligners to gradually align teeth and address issues like overcrowding and bite problems, enhancing both appearance and function',
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ServiceCard(
                                    title: 'Laser Dentistry',
                                    imagePath: 'assets/cards/laser-beam.png',
                                    description:
                                        'Laser dentistry utilizes laser technology for precise and minimally invasive dental procedures, offering benefits like reduced discomfort, faster healing, and greater precision compared to traditional methods. It encompasses treatments for gum disease, cavity preparation, tooth whitening, and soft tissue procedures, providing patients with a more comfortable and efficient dental experience.',
                                  ),
                                  ServiceCard(
                                    title: 'Teeth Whitening',
                                    imagePath: 'assets/cards/healthy-tooth.png',
                                    description:
                                        'Teeth whitening is a cosmetic dental procedure that aims to lighten teeth and remove stains. It can be done using bleaching agents like hydrogen peroxide. This safe and effective treatment enhances smile appearance, though results may vary based on staining severity and oral health.',
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ServiceCard(
                                    title: 'Root Canal',
                                    imagePath: 'assets/cards/root-canal.png',
                                    description:
                                        'A root canal is a dental procedure that addresses infected or damaged tooth pulp by removing the affected tissue, cleaning the inside of the tooth, and sealing it to prevent further infection. This treatment alleviates pain, preserves the tooth, and restores its function, often followed by the placement of a crown for added protection and strength.',
                                  ),
                                  ServiceCard(
                                    title: 'Gum Depigmentation',
                                    imagePath: 'assets/cards/infection.png',
                                    description:
                                        'Gum depigmentation is a cosmetic dental procedure that reduces dark spots on the gums caused by excess melanin pigmentation. It involves techniques like laser treatment or surgical scraping to remove pigmented tissue, revealing lighter-colored gums underneath. This procedure improves smile aesthetics and is safe and effective for achieving a more uniform gum line.',
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ServiceCard(
                                    title: 'Dental Fillings',
                                    imagePath: 'assets/cards/tooth-filling.png',
                                    description:
                                        'Dental fillings are materials used to repair teeth damaged by decay, fractures, or wear. Dentists remove the damaged portion of the tooth and fill the space with materials like amalgam or composite resin to restore its strength and function. Fillings prevent further decay, restore appearance, and aid in chewing.',
                                  ),
                                  ServiceCard(
                                    title: 'Crowns & Bridges',
                                    imagePath: 'assets/cards/bridge.png',
                                    description:
                                        'Crowns are covers used to repair damaged teeth, while bridges replace missing teeth by bridging the gap between adjacent teeth. Crowns restore the shape, strength, and appearance of a tooth, while bridges restore chewing function and maintain tooth alignment. Both are custom-made restorations that provide long-lasting solutions for dental issues.',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          height: 755,
                          width: 300,
                        ),
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
