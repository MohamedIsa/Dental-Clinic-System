import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senior/const/app_colors.dart';
import '../../../../../functions/createfaculty/deleteuser.dart';
import '../../../../../functions/createfaculty/hideuser.dart';
import '../../../../../functions/createfaculty/restoreuser.dart';
import '../../../../../functions/createfaculty/userrole.dart';

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
        title: Text('Staff Management'),
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
                            onPressed: () =>
                                hideUser(context, userDoc.id, role),
                          ),
                          SizedBox(width: 20),
                          IconButton(
                            icon: Icon(Icons.restore),
                            onPressed: () => restoreUser(context, userDoc.id),
                          ),
                          SizedBox(width: 20),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () =>
                                deleteUser(context, userDoc.id, role),
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
        onPressed: () {
          Navigator.pushNamed(context, "/addstaff");
          // showDialog(
          //   context: context,
          //   builder: (context) {
          //     String selectedGender = 'Male';
          //     String selectedRole = 'Admin';

          //     return AlertDialog(
          //       title: Text('Add Staff Member'),
          //       content: SingleChildScrollView(
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             TextFormField(
          //               controller: fullNameController,
          //               decoration: InputDecoration(labelText: 'Full Name'),
          //             ),
          //             TextFormField(
          //               controller: cprController,
          //               decoration: InputDecoration(labelText: 'CPR'),
          //             ),
          //             TextFormField(
          //               controller: emailController,
          //               decoration: InputDecoration(labelText: 'Email'),
          //             ),
          //             TextFormField(
          //               controller: phoneNumberController,
          //               decoration: InputDecoration(labelText: 'Phone Number'),
          //             ),
          //             TextFormField(
          //               controller: birthdayController,
          //               decoration: InputDecoration(labelText: 'Birthday'),
          //             ),
          //             DropdownButtonFormField<String>(
          //               value: selectedGender,
          //               decoration: InputDecoration(labelText: 'Gender'),
          //               items: ['Male', 'Female']
          //                   .map((gender) => DropdownMenuItem(
          //                         value: gender,
          //                         child: Text(gender),
          //                       ))
          //                   .toList(),
          //               onChanged: (value) {
          //                 setState(() {
          //                   selectedGender = value!;
          //                 });
          //               },
          //             ),
          //             DropdownButtonFormField<String>(
          //               value: selectedRole,
          //               decoration: InputDecoration(labelText: 'Role'),
          //               items: [
          //                 'Admin',
          //                 'Receptionist',
          //                 'Dentist',
          //               ]
          //                   .map((role) => DropdownMenuItem(
          //                         value: role,
          //                         child: Text(role),
          //                       ))
          //                   .toList(),
          //               onChanged: (value) {
          //                 setState(() {
          //                   selectedRole = value!;
          //                 });
          //               },
          //             ),
          //           ],
          //         ),
          //       ),
          //       actions: [
          //         TextButton(
          //           onPressed: () {
          //             Navigator.of(context).pop();
          //           },
          //           child: Text('Cancel'),
          //         ),
          //         ElevatedButton(
          //           onPressed: () => check(
          //             context,
          //             null,
          //             emailTextController,
          //             fullNameTextController,
          //             cprTextController,
          //             phoneTextController,
          //             selectedGender,
          //             dobTextController,
          //             selectedRole
          //           ),

          //             // if (fullNameController.text.isNotEmpty &&
          //             //     cprController.text.isNotEmpty &&
          //             //     emailController.text.isNotEmpty &&
          //             //     phoneNumberController.text.isNotEmpty &&
          //             //     birthdayController.text.isNotEmpty) {
          //             //   String cpr = cprController.text;
          //             //   String email = emailController.text;
          //             //   String phoneNumber = phoneNumberController.text;
          //             //   String birthday = birthdayController.text;
          //             //   String fullName = fullNameController.text;
          //             //   QuerySnapshot emailResult = await _firestore
          //             //       .collection('user')
          //             //       .where('Email', isEqualTo: email)
          //             //       .get();
          //             //   if (!RegExp(emailPattern).hasMatch(email)) {
          //             //     showErrorDialog(context, 'Invalid email format.');
          //             //     return;
          //             //   }

          //             //   if (emailResult.docs.isNotEmpty) {
          //             //     showErrorDialog(context, 'Email already exists.');
          //             //     return;
          //             //   }

          //             //   if (fullName.isEmpty) {
          //             //     showErrorDialog(
          //             //         context, 'Full name cannot be empty.');
          //             //     return;
          //             //   }

          //             //   if (!RegExp(PhonePattern).hasMatch(phoneNumber)) {
          //             //     showErrorDialog(context, 'Invalid Phone format.');
          //             //     return;
          //             //   }
          //             //   if (!RegExp(CPRPattern).hasMatch(cpr)) {
          //             //     showErrorDialog(context, 'Invalid CPR format.');
          //             //     return;
          //             //   }
          //             //   if (isValidBirthday(birthday) == false) {
          //             //     showErrorDialog(context, 'Invalid birthday.');
          //             //     return;
          //             //   }

          //             //   QuerySnapshot result = await _firestore
          //             //       .collection('user')
          //             //       .where('CPR', isEqualTo: cpr)
          //             //       .get();
          //             //   if (result.docs.isNotEmpty) {
          //             //     showErrorDialog(context, 'CPR already exists.');
          //             //     return;
          //             //   }

          //             //   try {
          //             //     String randomPassword = generateRandomPassword();

          //             //     UserCredential userCredential = await FirebaseAuth
          //             //         .instance
          //             //         .createUserWithEmailAndPassword(
          //             //       email: emailController.text,
          //             //       password: randomPassword,
          //             //     );

          //             //     await userCredential.user?.sendEmailVerification();
          //             //     await FirebaseAuth.instance.sendPasswordResetEmail(
          //             //         email: emailController.text);

          //             //     DocumentReference userRef = FirebaseFirestore.instance
          //             //         .collection('user')
          //             //         .doc(userCredential.user?.uid);

          //             //     await userRef.set({
          //             //       'FullName': fullNameController.text,
          //             //       'CPR': cprController.text,
          //             //       'Email': emailController.text,
          //             //       'Phone': phoneNumberController.text,
          //             //       'DOB': birthdayController.text,
          //             //       'Gender': selectedGender,
          //             //     });

          //             //     String roleCollection;
          //             //     Map<String, dynamic> userData = {
          //             //       'uid': userCredential.user?.uid
          //             //     };

          //             //     if (selectedRole == 'Dentist') {
          //             //       roleCollection = 'dentist';
          //             //       userData['color'] = '4280391411';
          //             //     } else if (selectedRole == 'Admin') {
          //             //       roleCollection = 'admin';
          //             //     } else {
          //             //       roleCollection = 'receptionist';
          //             //     }

          //             //     await FirebaseFirestore.instance
          //             //         .collection(roleCollection)
          //             //         .doc(userCredential.user?.uid)
          //             //         .set(userData);

          //             //     Navigator.of(context).pop();
          //             //   } catch (e) {
          //             //     print('Error: $e');
          //             //     showErrorDialog(context,
          //             //         'An error occurred while saving the user.');
          //             //   }
          //             // } else {
          //             //   showErrorDialog(context, 'Please fill in all fields.');
          //             // }

          //           child: Text('Save'),
          //         ),
          //       ],
          //     );
          //   },
          // );
        },
      ),
    );
  }
}
