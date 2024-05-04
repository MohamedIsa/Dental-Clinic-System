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
<<<<<<< HEAD
                    final role = snapshot.data;
                    if (role == null) {
                      // Skip rendering ListTile for roles other than admin, dentist, or receptionist
=======
                    final role = snapshot.data ?? '';
                    if (role.isEmpty) {
                      // Exclude patients from the list
>>>>>>> cc3e0fe23e2e3f169f8cf8db67808a115eace35f
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
                          _deleteUser(userDoc.id);
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
                        'fullName': fullNameController.text,
                        'CPR': cprController.text,
                        'email': emailController.text,
                        'phoneNumber': phoneNumberController.text,
                        'birthday': birthdayController.text,
                        'gender': selectedGender,
                        if (selectedRole == 'Admin') ...{
                          'role': 'Admin',
                        } else if (selectedRole == 'Receptionist') ...{
                          'role': 'Receptionist',
                        } else if (selectedRole == 'Dentist') ...{
                          'role': 'Dentist',
                        },
                      }).then((_) {
                        Navigator.of(context).pop(); // Close the dialog after saving
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

<<<<<<< HEAD
=======
    // Check if the user is a patient
    var patientDoc =
        await FirebaseFirestore.instance.collection('patient').doc(userId).get();
    if (patientDoc.exists) {
      // If the user is a patient, return an empty string to exclude them from the staff list
      return '';
    }

    // If the user is not a patient, check their role in other collections
>>>>>>> cc3e0fe23e2e3f169f8cf8db67808a115eace35f
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

  Future<void> _deleteUser(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('user').doc(userId).delete();
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

class EditCouponScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Coupon'),
      ),
      body: Center(
        child: Text('Edit Coupon Screen'),
      ),
    );
  }
}
