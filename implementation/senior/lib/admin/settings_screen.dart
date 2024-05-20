import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senior/reuseable_widget.dart';

class SettingsPage extends StatelessWidget {
  final Function(String) navigateToSettings;

  const SettingsPage({Key? key, required this.navigateToSettings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Container(
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white, // Set the border color
                    width: 1.0, // Set the border width
                  ),
                ),
              ),
              child: ListTile(
                title: Text(
                  'Staff Management',
                  style: TextStyle(
                    color: Colors.white, // Set the text color to white
                  ),
                ),
                tileColor: const Color.fromARGB(
                    255, 38, 99, 148), // Set the tile color to blue
                onTap: () {
                  navigateToSettings('Staff Management');
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white, // Set the border color
                    width: 1.0, // Set the border width
                  ),
                ),
              ),
              child: ListTile(
                title: Text(
                  'Dentist Color',
                  style: TextStyle(
                    color: Colors.white, // Set the text color to white
                  ),
                ),
                tileColor: const Color.fromARGB(
                    255, 38, 99, 148), // Set the tile color to blue
                onTap: () {
                  navigateToSettings('Dentist Color');
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white, // Set the border color
                    width: 1.0, // Set the border width
                  ),
                ),
              ),
              child: ListTile(
                title: Text(
                  'Edit Message',
                  style: TextStyle(
                    color: Colors.white, // Set the text color to white
                  ),
                ),
                tileColor: const Color.fromARGB(
                    255, 38, 99, 148), // Set the tile color to blue
                onTap: () {
                  navigateToSettings('Edit Message');
                },
              ),
            ),
          ],
        ),
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
        title: Text(
          'Settings',
          style:
              TextStyle(color: Colors.white), // Set app bar text color to white
        ),
        backgroundColor: Colors.blue, // Set app bar background color to blue
      ),
      body: Container(
        color:
            Colors.blue, // Set background color of the SettingsScreen to blue
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 7,
                child: SettingsPage(
                  navigateToSettings: (settingName) {
                    // Implement navigation logic here
                    switch (settingName) {
                      case 'Staff Management':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StaffManagementScreen()),
                        );
                        break;
                      case 'Dentist Color':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DentistColorSettingsScreen()),
                        );
                        break;
                      case 'Edit Message':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditMessageScreen()),
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
      ),
    );
  }
}

class DentistColorSettingsScreen extends StatefulWidget {
  const DentistColorSettingsScreen({Key? key, this.uid});

  final String? uid;

  @override
  _DentistColorSettingsScreenState createState() =>
      _DentistColorSettingsScreenState();
}

class _DentistColorSettingsScreenState
    extends State<DentistColorSettingsScreen> {
  Map<String, String> userColors = {}; // Store color values for each user

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dentist Color Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('dentist').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final dentistDocs = snapshot.data?.docs;

          if (dentistDocs == null || dentistDocs.isEmpty) {
            return Center(child: Text('No dentist data found'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Center(
                  child: Text(
                    'Table of Dentists',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Full Name')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Color')),
                      ],
                      rows: dentistDocs.map((dentistDoc) {
                        final dentistUID =
                            dentistDoc.id; // Assuming UID is the document ID
                        return DataRow(cells: [
                          DataCell(
                            FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('user')
                                  .doc(dentistUID)
                                  .get(),
                              builder: (context, userSnapshot) {
                                if (userSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (userSnapshot.hasError) {
                                  return Center(
                                      child:
                                          Text('Error: ${userSnapshot.error}'));
                                }

                                final Map<String, dynamic>? userData =
                                    userSnapshot.data?.data()
                                        as Map<String, dynamic>?;

                                if (userData == null) {
                                  return Text('User data not found');
                                }

                                final fullName =
                                    userData['FullName'] ?? 'No Full Name';
                                return Text(fullName);
                              },
                            ),
                          ),
                          DataCell(
                            FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('user')
                                  .doc(dentistUID)
                                  .get(),
                              builder: (context, userSnapshot) {
                                if (userSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (userSnapshot.hasError) {
                                  return Center(
                                      child:
                                          Text('Error: ${userSnapshot.error}'));
                                }

                                final Map<String, dynamic>? userData =
                                    userSnapshot.data?.data()
                                        as Map<String, dynamic>?;

                                if (userData == null) {
                                  return Text('User data not found');
                                }

                                final email = userData['Email'] ?? 'No Email';
                                return Text(email);
                              },
                            ),
                          ),
                          DataCell(
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    Color selectedColor =
                                        userColors[dentistUID] != null
                                            ? Color(int.parse(
                                                userColors[dentistUID]!))
                                            : Colors.blue; // Default color

                                    return AlertDialog(
                                      title: Text('Select a color'),
                                      content: SingleChildScrollView(
                                        child: ColorPicker(
                                          borderColor: selectedColor,
                                          color: selectedColor,
                                          onColorChanged: (Color color) {
                                            setState(() {
                                              selectedColor = color;
                                            });
                                          },
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              userColors[dentistUID] = selectedColor
                                                  .value
                                                  .toString(); // Update color value in userColors map
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text('Choose Color'),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 16), // Adjust the width as needed
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue, // Set background color of the button
                  borderRadius: BorderRadius.circular(
                      8), // Optional: adjust the border radius
                ),
                child: TextButton(
                  onPressed: () {
                    // Handle cancel action
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: Colors.white), // Set text color to white
                  ),
                ),
              ),
              SizedBox(width: 16), // Adjust the width as needed
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue, // Set background color of the button
                  borderRadius: BorderRadius.circular(
                      8), // Optional: adjust the border radius
                ),
                child: TextButton(
                  onPressed: () async {
                    // Iterate through userColors map to update colors in Firebase
                    userColors.forEach((dentistUID, color) async {
                      try {
                        // Update color for the dentist in Firebase
                        await FirebaseFirestore.instance
                            .collection('dentist')
                            .doc(dentistUID)
                            .update({'color': color});
                        showMessagealert(context, 'Color Updated Successfully');
                      } catch (e) {
                        print(
                            'Error updating color for dentist $dentistUID: $e');
                        showErrorDialog(
                            context, 'Error updating color for dentist: $e');
                      }
                    });
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(
                        color: Colors.white), // Set text color to white
                  ),
                ),
              ),
            ],
          ),
        ),
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
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No staff data found'),
            );
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
                builder: (context, roleSnapshot) {
                  if (roleSnapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox.shrink();
                  } else if (roleSnapshot.hasError) {
                    return Text('Error: ${roleSnapshot.error}');
                  } else {
                    final role = roleSnapshot.data;
                    if (role == null ||
                        !['admin', 'dentist', 'receptionist', 'unavailable']
                            .contains(role.toLowerCase())) {
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.hide_image),
                            onPressed: () {
                              _hideUser(context, userDoc.id, role);
                            },
                          ),
                          SizedBox(width: 20),
                          IconButton(
                            icon: Icon(Icons.restore),
                            onPressed: () {
                              _restoreUser(context, userDoc.id);
                            },
                          ),
                          SizedBox(width: 20),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteUser(context, userDoc.id, role);
                            },
                          ),
                        ],
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
                          setState(() {
                            selectedGender = value!;
                          });
                        },
                      ),
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        decoration: InputDecoration(labelText: 'Role'),
                        items: [
                          'Admin',
                          'Receptionist',
                          'Dentist',
                        ]
                            .map((role) => DropdownMenuItem(
                                  value: role,
                                  child: Text(role),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value!;
                          });
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
                    onPressed: () async {
                      if (fullNameController.text.isNotEmpty &&
                          cprController.text.isNotEmpty &&
                          emailController.text.isNotEmpty &&
                          phoneNumberController.text.isNotEmpty &&
                          birthdayController.text.isNotEmpty) {
                        try {
                          // Generate a random password
                          String randomPassword = generateRandomPassword();

                          // Create the user in Firebase Authentication
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: randomPassword,
                          );

                          // Send a password reset email to the user
                          await userCredential.user?.sendEmailVerification();
                          await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: emailController.text);

                          // Add data to 'user' collection in Firestore
                          DocumentReference userRef = FirebaseFirestore.instance
                              .collection('user')
                              .doc(userCredential.user?.uid);

                          await userRef.set({
                            'FullName': fullNameController.text,
                            'CPR': cprController.text,
                            'Email': emailController.text,
                            'Phone': phoneNumberController.text,
                            'DOB': birthdayController.text,
                            'Gender': selectedGender,
                          });

                          // Add UID to the respective role collection in Firestore
                          String roleCollection;
                          Map<String, dynamic> userData = {
                            'uid': userCredential.user?.uid
                          };

                          if (selectedRole == 'Dentist') {
                            roleCollection = 'dentist';
                            userData['color'] =
                                'blue'; // Add color if role is Dentist
                          } else if (selectedRole == 'Admin') {
                            roleCollection = 'admin';
                          } else {
                            roleCollection = 'receptionist';
                          }

                          await FirebaseFirestore.instance
                              .collection(roleCollection)
                              .doc(userCredential.user?.uid)
                              .get();

                          Navigator.of(context).pop();
                        } catch (e) {
                          print('Error: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'An error occurred. Please try again later.'),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please fill in all fields.'),
                          ),
                        );
                      }
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
}

Future<String?> _getUserRole(String userId) async {
  String? role;

  var adminDoc =
      await FirebaseFirestore.instance.collection('admin').doc(userId).get();
  if (adminDoc.exists) {
    role = 'Admin';
  } else {
    var dentistDoc = await FirebaseFirestore.instance
        .collection('dentist')
        .doc(userId)
        .get();
    if (dentistDoc.exists) {
      role = 'Dentist';
    } else {
      var receptionistDoc = await FirebaseFirestore.instance
          .collection('receptionist')
          .doc(userId)
          .get();
      if (receptionistDoc.exists) {
        role = 'Receptionist';
      } else {
        var unavailableDoc = await FirebaseFirestore.instance
            .collection('unavailable')
            .doc(userId)
            .get();
        if (unavailableDoc.exists) {
          role = 'Unavailable';
        } else {
          role = null;
        }
      }
    }
  }

  return role;
}

Future<void> _deleteUser(context, String userId, String role) async {
  try {
    // Depending on the user's role, delete from respective collections
    if (role.toLowerCase() == 'admin') {
      await FirebaseFirestore.instance.collection('admin').doc(userId).delete();
    } else if (role.toLowerCase() == 'dentist') {
      await FirebaseFirestore.instance
          .collection('dentist')
          .doc(userId)
          .delete();
    } else if (role.toLowerCase() == 'receptionist') {
      await FirebaseFirestore.instance
          .collection('receptionist')
          .doc(userId)
          .delete();
    }
    showMessagealert(context, 'User Deleted Successfully');
  } catch (e) {
    print('Error deleting user: $e');
    // Handle error here
  }
}

Future<void> _hideUser(context, String userId, String role) async {
  try {
    // Depending on the user's role, delete from respective collections
    if (role.toLowerCase() == 'admin') {
      await FirebaseFirestore.instance.collection('admin').doc(userId).delete();
      await FirebaseFirestore.instance
          .collection('unavailable')
          .doc(userId)
          .set({'uid': userId, 'role': 'admin'});
    } else if (role.toLowerCase() == 'dentist') {
      await FirebaseFirestore.instance
          .collection('dentist')
          .doc(userId)
          .delete();
      await FirebaseFirestore.instance
          .collection('unavailable')
          .doc(userId)
          .set({'uid': userId, 'role': 'dentist'});
    } else if (role.toLowerCase() == 'receptionist') {
      await FirebaseFirestore.instance
          .collection('receptionist')
          .doc(userId)
          .delete();
      await FirebaseFirestore.instance
          .collection('unavailable')
          .doc(userId)
          .set({'uid': userId, 'role': 'receptionist'});
    }
    showMessagealert(context, 'User Hidden Successfully');
  } catch (e) {
    print('Error deleting user: $e');
    // Handle error here
  }
}

Future<void> _restoreUser(context, String userId) async {
  try {
    // Fetch the user document from the 'unavailable' collection based on the UID
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('unavailable')
        .where('uid', isEqualTo: userId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Extract user data from the fetched document
      Map<String, dynamic> userData = snapshot.docs.first.data();

      // Extract the UID and role from the user data
      String? role = userData['role'];

      if (role == null) {
        throw Exception('Role not found for user');
      }

      // Create a new document with only the UID
      Map<String, dynamic> newUserData = {'uid': userId};

      // Determine the target collection based on the role
      String targetCollection;
      switch (role.toLowerCase()) {
        case 'admin':
          targetCollection = 'admin';
          break;
        case 'dentist':
          targetCollection = 'dentist';
          break;
        case 'receptionist':
          targetCollection = 'receptionist';
          break;
        default:
          throw Exception('Invalid role specified');
      }

      // Write the new document to the target collection
      await FirebaseFirestore.instance
          .collection(targetCollection)
          .doc(userId)
          .set(newUserData);

      // Delete the document from the 'unavailable' collection
      await snapshot.docs.first.reference.delete();
      showMessagealert(context, 'User Restored Successfully');
    } else {
      throw Exception('User not found in unavailable collection');
    }
  } catch (e) {
    showErrorDialog(context, 'Error restoring user: $e');
  }
}

class EditMessageScreen extends StatefulWidget {
  @override
  _EditWelcomeMessageScreenState createState() =>
      _EditWelcomeMessageScreenState();
}

class _EditWelcomeMessageScreenState extends State<EditMessageScreen> {
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

  Future<void> _updateWelcomeMessage(
      BuildContext context, String newMessage) async {
    try {
      await FirebaseFirestore.instance
          .collection('welcome')
          .doc('mgAMaIIGgWZTnNl0d32B')
          .set({'message': newMessage});
      showMessagealert(context, 'Welcome Message Updated Successfully');
    } catch (e) {
      showErrorDialog(context, 'Error updating welcome message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Welcome Message',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
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
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
              maxLines: null, // Allow multiline input
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _updateWelcomeMessage(context,
                    _welcomeMessageController.text); // Pass context here
              },
              child: Text(
                'Update Welcome Message',
                style: TextStyle(color: Colors.blue),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blue,
    );
  }
}

String generateRandomPassword({int length = 12}) {
  const characters =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  Random random = Random();
  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => characters.codeUnitAt(random.nextInt(characters.length)),
    ),
  );
}
