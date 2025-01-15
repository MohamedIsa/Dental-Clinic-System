import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:senior/utils/popups.dart';

class DentistColorSettingsScreen extends StatefulWidget {
  const DentistColorSettingsScreen({super.key, this.uid});

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
