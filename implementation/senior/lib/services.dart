import 'package:flutter/material.dart';
import 'package:senior/responsive_widget.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  int _selectedIndex = 1;

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
              'Dental Services',
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
                  _selectedIndex = index;
                });
                switch (index) {
                  case 0:
                    Navigator.pushNamed(
                      context,
                      '/home',
                    );
                    break;
                  case 1:
                    // Handle 'Dental Services' tab
                    break;
                  case 2:
                    Navigator.pushNamed(
                      context,
                      '/aboutus',
                    );
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
              ServiceList(), // This is where the ServiceList widget is included
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceList extends StatelessWidget {
  final List<Map<String, String>> services = [
    {
      'title': 'Dental Implants',
      'imagePath': 'assets/cards/implant.png',
      'description':
          'Dental implants are titanium tooth roots placed into the jawbone to support replacement teeth. They offer a durable and natural-looking solution for missing teeth, enhancing chewing, speech, and overall oral health'
    },
    {
      'title': 'Orthodontics',
      'imagePath': 'assets/cards/braces.png',
      'description':
          'Orthodontics is a dental specialty aimed at correcting misaligned teeth and jaws for improved oral health and aesthetics. Treatments involve braces or aligners to gradually align teeth and address issues like overcrowding and bite problems, enhancing both appearance and function',
    },
    {
      'title': 'Laser Dentistry',
      'imagePath': 'assets/cards/laser-beam.png',
      'description':
          'Laser dentistry utilizes laser technology for precise and minimally invasive dental procedures, offering benefits like reduced discomfort, faster healing, and greater precision compared to traditional methods. It encompasses treatments for gum disease, cavity preparation, tooth whitening, and soft tissue procedures, providing patients with a more comfortable and efficient dental experience.',
    },
    {
      'title': 'Teeth Whitening',
      'imagePath': 'assets/cards/healthy-tooth.png',
      'description':
          'Teeth whitening is a cosmetic dental procedure that aims to lighten teeth and remove stains. It can be done using bleaching agents like hydrogen peroxide. This safe and effective treatment enhances smile appearance, though results may vary based on staining severity and oral health.',
    },
    {
      'title': 'Root Canal',
      'imagePath': 'assets/cards/root-canal.png',
      'description':
          'A root canal is a dental procedure that addresses infected or damaged tooth pulp by removing the affected tissue, cleaning the inside of the tooth, and sealing it to prevent further infection. This treatment alleviates pain, preserves the tooth, and restores its function, often followed by the placement of a crown for added protection and strength.',
    },
    {
      'title': 'Gum Depigmentation',
      'imagePath': 'assets/cards/infection.png',
      'description':
          'Gum depigmentation is a cosmetic dental procedure that reduces dark spots on the gums caused by excess melanin pigmentation. It involves techniques like laser treatment or surgical scraping to remove pigmented tissue, revealing lighter-colored gums underneath. This procedure improves smile aesthetics and is safe and effective for achieving a more uniform gum line.',
    },
    {
      'title': 'Dental Fillings',
      'imagePath': 'assets/cards/tooth-filling.png',
      'description':
          'Dental fillings are materials used to repair teeth damaged by decay, fractures, or wear. Dentists remove the damaged portion of the tooth and fill the space with materials like amalgam or composite resin to restore its strength and function. Fillings prevent further decay, restore appearance, and aid in chewing.',
    },
    {
      'title': 'Crowns & Bridges',
      'imagePath': 'assets/cards/bridge.png',
      'description':
          'Crowns are covers used to repair damaged teeth, while bridges replace missing teeth by bridging the gap between adjacent teeth. Crowns restore the shape, strength, and appearance of a tooth, while bridges restore chewing function and maintain tooth alignment. Both are custom-made restorations that provide long-lasting solutions for dental issues.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: services.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 1),
            color: Colors.blue[300],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(
                services[index]['title']!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(services[index]['description']!),
              leading: Image.asset(services[index]['imagePath']!),
            ),
          ),
        );
      },
    );
  }
}
