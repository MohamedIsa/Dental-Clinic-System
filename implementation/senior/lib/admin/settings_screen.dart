import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senior/admin/side_menu_widget.dart';

class SettingsPage extends StatelessWidget {
  final Function(String) navigateToSettings;

  const SettingsPage({Key? key, required this.navigateToSettings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: ListView(
        children: [
          ListTile(
            title: Text('General Settings'),
            onTap: () {
              navigateToSettings('General Settings');
            },
          ),
          ListTile(
            title: Text('Appointment Settings'),
            onTap: () {
              navigateToSettings('Appointment Settings');
            },
          ),
          ListTile(
            title: Text('Staff Management'),
            onTap: () {
              navigateToSettings('Staff Management');
            },
          ),
          ListTile(
            title: Text('Edit Coupon'),
            onTap: () {
              navigateToSettings('Edit Coupon');
            },
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: SideMenuWidget(),
            ),
            Expanded(
              flex: 7,
              child: SettingsPage(
                navigateToSettings: (settingName) {
                  // Implement navigation logic here
                  switch (settingName) {
                    case 'General Settings':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GeneralSettingsScreen()),
                      );
                      break;
                    case 'Appointment Settings':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AppointmentSettingsScreen()),
                      );
                      break;
                    case 'Staff Management':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StaffManagementScreen()),
                      );
                      break;
                    case 'Notifications and Alerts':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NotificationsScreen()),
                      );
                      break;
                    case 'Edit Coupon':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditCouponScreen()),
                      );
                      break;
                    default:
                      print('Setting not found');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GeneralSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('General Settings'),
      ),
      body: Center(
        child: Text('General Settings Screen'),
      ),
    );
  }
}

class AppointmentSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Settings'),
      ),
      body: Center(
        child: Text('Appointment Settings Screen'),
      ),
    );
  }
}
class StaffManagementScreen extends StatefulWidget {
  const StaffManagementScreen({Key? key}) : super(key: key);

  @override
  _StaffManagementScreenState createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController cprController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    fullNameController.dispose();
    cprController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Staff Management'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('user').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Text('No staff data found');
          }

          final userDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: userDocs.length,
            itemBuilder: (context, index) {
              final userDoc = userDocs[index];
              final name = userDoc['FullName'];
              final email = userDoc['Email'];

              return FutureBuilder<String?>(
                future: _getUserRole(userDoc.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox.shrink();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final role = snapshot.data;
                    if (role == null) {
                      // Skip rendering ListTile for roles other than admin, dentist, or receptionist
                      return SizedBox.shrink();
                    }
                    return ListTile(
                      title: Text(name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(email),
                          Text(role),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteUser(userDoc.id, role); // Pass role here
                        },
                      ),
                      onTap: () {
                        // Handle staff item tap
                        // You can navigate to an edit screen or perform other actions
                      },
                    );
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String selectedGender = 'Male'; // Default value for gender
              String selectedRole = 'Admin'; // Default value for role

              return AlertDialog(
                title: Text('Add Staff Member'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: fullNameController,
                        decoration: InputDecoration(labelText: 'Full Name'),
                      ),
                      TextFormField(
                        controller: cprController,
                        decoration: InputDecoration(labelText: 'CPR'),
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                      TextFormField(
                        controller: phoneNumberController,
                        decoration: InputDecoration(labelText: 'Phone Number'),
                      ),
                      TextFormField(
                        controller: birthdayController,
                        decoration: InputDecoration(labelText: 'Birthday'),
                      ),
                      DropdownButtonFormField<String>(
                        value: selectedGender,
                        decoration: InputDecoration(labelText: 'Gender'),
                        items: ['Male', 'Female']
                            .map((gender) => DropdownMenuItem(
                                  value: gender,
                                  child: Text(gender),
                                ))
                            .toList(),
                        onChanged: (value) {
                          selectedGender = value!;
                        },
                      ),
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        decoration: InputDecoration(labelText: 'Role'),
                        items: ['Admin', 'Receptionist', 'Dentist']
                            .map((role) => DropdownMenuItem(
                                  value: role,
                                  child: Text(role),
                                ))
                            .toList(),
                        onChanged: (value) {
                          selectedRole = value!;
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                 ElevatedButton(
  onPressed: () {
    // Save staff member data to Firestore
    _firestore.collection('user').add({
      'FullName': fullNameController.text,
      'CPR': cprController.text,
      'Email': emailController.text,
      'Phone': phoneNumberController.text,
      'DOB': birthdayController.text,
      'Gender': selectedGender,
    }).then((documentReference) {
      // Get the ID of the newly added document
      String userId = documentReference.id;
      
      // Determine the role collection based on selectedRole
      String roleCollection;
      if (selectedRole == 'Admin') {
        roleCollection = 'admin';
      } else if (selectedRole == 'Dentist') {
        roleCollection = 'dentist';
      } else {
        roleCollection = 'receptionist';
      }
      
      // Add user ID to the respective role collection
      _firestore.collection(roleCollection).doc(userId).set({
        'uid': userId,
      }).then((_) {
        Navigator.of(context).pop(); // Close the dialog after saving
      }).catchError((error) {
        print('Error saving staff member: $error');
        // Handle error here
      });
    }).catchError((error) {
      print('Error saving staff member: $error');
      // Handle error here
    });
  },
  child: Text('Save'),
),

                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<String?> _getUserRole(String userId) async {
    String? role;

    var adminDoc =
        await FirebaseFirestore.instance.collection('admin').doc(userId).get();
    if (adminDoc.exists) {
      role = 'Admin';
    } else {
      var dentistDoc =
          await FirebaseFirestore.instance.collection('dentist').doc(userId).get();
      if (dentistDoc.exists) {
        role = 'Dentist';
      } else {
        var receptionistDoc = await FirebaseFirestore.instance
            .collection('receptionist')
            .doc(userId)
            .get();
        if (receptionistDoc.exists) {
          role = 'Receptionist';
        }
      }
    }

    return role;
  }

  Future<void> _deleteUser(String userId, String role) async {
    try {
      // Delete the user document
      await FirebaseFirestore.instance.collection('user').doc(userId).delete();
      
      // Depending on the user's role, delete from respective collections
      if (role.toLowerCase() == 'admin') {
        await FirebaseFirestore.instance.collection('admin').doc(userId).delete();
      } else if (role.toLowerCase() == 'dentist') {
        await FirebaseFirestore.instance.collection('dentist').doc(userId).delete();
      } else if (role.toLowerCase() == 'receptionist') {
        await FirebaseFirestore.instance.collection('receptionist').doc(userId).delete();
      }
    } catch (e) {
      print('Error deleting user: $e');
    }
  }
}


class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications and Alerts'),
      ),
      body: Center(
        child: Text('Notifications and Alerts Screen'),
      ),
    );
  }
}
class EditWelcomeMessageScreen extends StatefulWidget {
  @override
  _EditWelcomeMessageScreenState createState() =>
      _EditWelcomeMessageScreenState();
}

class _EditWelcomeMessageScreenState extends State<EditWelcomeMessageScreen> {
  final TextEditingController _welcomeMessageController =
      TextEditingController();
  String _currentWelcomeMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchWelcomeMessage();
  }

Future<void> _fetchWelcomeMessage() async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('welcome')
        .doc('mgAMaIIGgWZTnNl0d32B')
        .get();

    if (snapshot.exists) {
      final data = snapshot.data();
      if (data != null && data.containsKey('message')) {
        final message = data['message'];
        if (message is String) {
          _updateWelcomeMessageText(message);
        } else {
          print('Welcome message is not a String: $message');
        }
      } else {
        print('Document does not contain a "message" field.');
      }
    } else {
      print('Document does not exist. Cannot fetch welcome message.');
    }
  } catch (e, stackTrace) {
    print('Error fetching welcome message: $e\n$stackTrace');
  }
}

  void _updateWelcomeMessageText(String? message) {
    setState(() {
      _currentWelcomeMessage = message ?? '';
      _welcomeMessageController.text = _currentWelcomeMessage;
    });
  }

  Future<void> _updateWelcomeMessage(String newMessage) async {
    try {
      await FirebaseFirestore.instance
          .collection('welcome')
          .doc('mgAMaIIGgWZTnNl0d32B')
          .set({'message': newMessage});
      print('Welcome message updated successfully!');
    } catch (e) {
      print('Error updating welcome message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Welcome Message'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _welcomeMessageController,
              decoration: InputDecoration(
                labelText: 'Welcome Message',
              ),
              maxLines: null, // Allow multiline input
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _updateWelcomeMessage(_welcomeMessageController.text);
              },
              child: Text('Update Welcome Message'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditCouponScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Coupon'),
      ),
      body: ListView(
        children: <Widget>[
          CouponListTile(
            title: 'Create Coupon',
            onTap: () {
              // Add your onTap functionality here
              print('Create Coupon tapped!');
            },
          ),
          CouponListTile(
            title: 'Edit Welcome Message',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditWelcomeMessageScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CouponListTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const CouponListTile({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
    );
  }
}