import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DentistsDataTable extends StatefulWidget {
  const DentistsDataTable({Key? key, this.uid});

  final String? uid;

  @override
  _DentistsDataTableState createState() => _DentistsDataTableState();
}

class _DentistsDataTableState extends State<DentistsDataTable> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('dentist').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final dentistDocs = snapshot.data?.docs;

        if (dentistDocs == null || dentistDocs.isEmpty) {
          return Text('No dentist data found');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Table of Dentists',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Full Name')),
                    DataColumn(label: Text('Email')),
                  ],
                  rows: dentistDocs.map((dentistDoc) {
                    final dentistUID = dentistDoc['uid']; // Assuming UID is stored in the dentist document
                    return DataRow(cells: [
                      DataCell(
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('user').doc(dentistUID).get(),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (userSnapshot.hasError) {
                              return Text('Error: ${userSnapshot.error}');
                            }

                            // Explicitly cast userData to Map<String, dynamic>
                            final Map<String, dynamic>? userData =
                                userSnapshot.data?.data() as Map<String, dynamic>?;

                            if (userData == null) {
                              return Text('User data not found');
                            }

                            // Access fields using null-aware operators
                            final fullName = userData['FullName'] ?? 'No Full Name';
                            return Text(fullName);
                          },
                        ),
                      ),
                      DataCell(
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('user').doc(dentistUID).get(),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (userSnapshot.hasError) {
                              return Text('Error: ${userSnapshot.error}');
                            }

                            // Explicitly cast userData to Map<String, dynamic>
                            final Map<String, dynamic>? userData =
                                userSnapshot.data?.data() as Map<String, dynamic>?;

                            if (userData == null) {
                              return Text('User data not found');
                            }

                            // Access fields using null-aware operators
                            final email = userData['Email'] ?? 'No Email';
                            return Text(email);
                          },
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
