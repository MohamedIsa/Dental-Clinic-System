import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
            title: Text('Notifications and Alerts'),
            onTap: () {
              navigateToSettings('Notifications and Alerts');
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
                    child: SideMenuWidget(), // Assuming you have a SideMenuWidget
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
                    return ListTile(
                      title: Text(name),
                      subtitle: Text(email),
                    );
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
        var _selectedRole;
        var _selectedGander;
        return AlertDialog(
          title: Text('Add Staff Member'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Full Name'),
                  // You can add validation logic here if needed
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'CPR'),
                  // You can add validation logic here if needed
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  // You can add validation logic here if needed
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  // You can add validation logic here if needed
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Birthday'),
                  // You can add validation logic here if needed
                ),
                DropdownButtonFormField<String>(
                  value: _selectedGander,
                  decoration: InputDecoration(labelText: 'Gander'),
                  items: ['Male', 'Female']
                      .map((gander) => DropdownMenuItem(
                            value: gander,
                            child: Text(gander),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGander = value!;
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: InputDecoration(labelText: 'Role'),
                  items: ['Admin', 'Receptionist', 'Dentist']
                      .map((role) => DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
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
              onPressed: () {
                // Add logic to save staff member
                Navigator.of(context).pop();
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
