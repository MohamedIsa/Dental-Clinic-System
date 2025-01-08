import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senior/pages/home/auth/facultyhome/patients/patientdetails/patientdetailspage.dart';
import '../../../../../functions/chat/seenmessage.dart';
import '../../../../../models/users.dart';
import '../../../../widgets/static/facilitypage.dart';
import 'patientbutton.dart';

class PatientScreen extends StatefulWidget {
  const PatientScreen({super.key});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  final TextEditingController searchTextController = TextEditingController();
  final ValueNotifier<String> searchQueryNotifier = ValueNotifier('');
  late CollectionReference chatCollection;

  @override
  void dispose() {
    searchTextController.dispose();
    searchQueryNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FacilityPage(
      widget: Expanded(
        flex: 9,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: PatientButtonsWidget(),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: searchTextController,
                decoration: const InputDecoration(
                  labelText: 'Search by CPR',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
                keyboardType: TextInputType.number,
                maxLength: 9,
                onChanged: (value) {
                  searchQueryNotifier.value = value;
                },
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<String>(
                valueListenable: searchQueryNotifier,
                builder: (context, searchQuery, _) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                            child: Text('No patient data found.'));
                      }

                      var filteredDocs = snapshot.data!.docs.where((doc) {
                        String name = (doc['name'] ?? '').toLowerCase();
                        String cpr = (doc['cpr'] ?? '').toLowerCase();
                        return name.contains(searchQuery.toLowerCase()) ||
                            cpr.contains(searchQuery.toLowerCase());
                      }).toList();

                      if (filteredDocs.isEmpty) {
                        return const Center(
                            child: Text('No matching patients found.'));
                      }

                      return FutureBuilder<List<Map<String, dynamic>>>(
                        future: Future.wait(filteredDocs.map((doc) async {
                          var chatCollection = FirebaseFirestore.instance
                              .collection('users')
                              .doc(doc['id'])
                              .collection('chat');
                          bool isSeen = await isMessageSeen(chatCollection);
                          return {
                            'doc': doc,
                            'isSeen': isSeen,
                          };
                        }).toList()),
                        builder: (context, futureSnapshot) {
                          if (futureSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (!futureSnapshot.hasData ||
                              futureSnapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No matching patients found.'));
                          }

                          var sortedDocs = futureSnapshot.data!;

                          sortedDocs.sort((a, b) {
                            if (a['isSeen'] && !b['isSeen']) {
                              return -1;
                            } else if (!a['isSeen'] && b['isSeen']) {
                              return 1;
                            }
                            return 0;
                          });

                          return ListView.builder(
                            itemCount: sortedDocs.length,
                            itemBuilder: (context, index) {
                              var patientDoc = sortedDocs[index]['doc'];
                              var patientData = Users(
                                id: patientDoc['id'],
                                name: patientDoc['name'] ?? '',
                                cpr: patientDoc['cpr'] ?? '',
                                dob: patientDoc['dob'] ?? '',
                                role: patientDoc['role'] ?? '',
                                gender: patientDoc['gender'] ?? '',
                                phone: patientDoc['phone'] ?? '',
                                email: patientDoc['email'] ?? '',
                              );

                              return ListTile(
                                title: Text(patientData.name),
                                subtitle: Text(patientData.cpr),
                                trailing: sortedDocs[index]['isSeen']
                                    ? const Icon(Icons.circle,
                                        color: Colors.red)
                                    : const Icon(Icons.circle,
                                        color: Colors.green),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PatientDetailsPage(
                                        patient: patientData,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
      widget1: null,
    );
  }
}
