import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:senior/const/app_colors.dart';
import '../../functions/createfaculty/deleteuser.dart';
import '../../functions/createfaculty/hideuser.dart';
import '../../functions/createfaculty/restoreuser.dart';
import '../../functions/createfaculty/userrole.dart';

class StaffManagementScreen extends StatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  _StaffManagementScreenState createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text('Staff Management',
            style: TextStyle(color: AppColors.whiteColor)),
        iconTheme: IconThemeData(color: AppColors.whiteColor),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
              child: Text(
                'No staff data found',
                style: TextStyle(color: AppColors.whiteColor),
              ),
            );
          }

          final userDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: userDocs.length,
            itemBuilder: (context, index) {
              final userDoc = userDocs[index];
              final name = userDoc['name'];
              final email = userDoc['email'];

              return FutureBuilder<String?>(
                future: getUserRole(userDoc.id),
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
                      title: Text(name,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                          )),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(email,
                              style: TextStyle(
                                color: AppColors.whiteColor,
                              )),
                          Text(role,
                              style: TextStyle(
                                color: AppColors.whiteColor,
                              )),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () =>
                                hideUser(context, userDoc.id, role),
                            child: Text('Hide',
                                style: TextStyle(color: AppColors.whiteColor)),
                          ),
                          SizedBox(width: 20),
                          TextButton(
                            onPressed: () => restoreUser(context, userDoc.id),
                            child: Text('Restore',
                                style: TextStyle(color: AppColors.whiteColor)),
                          ),
                          SizedBox(width: 20),
                          TextButton(
                            onPressed: () =>
                                deleteUser(context, userDoc.id, role),
                            child: Text('Delete',
                                style: TextStyle(color: AppColors.whiteColor)),
                          ),
                        ],
                      ),
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
        onPressed: () => context.go('/addstaff'),
      ),
    );
  }
}
