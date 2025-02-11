import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:senior/pages/patientdetails/patientdetailspage.dart';
import '../../functions/chat/seenmessage.dart';
import '../../models/users.dart';
import '../../utils/data.dart';

class PatientListPage extends StatefulWidget {
  const PatientListPage({super.key});

  @override
  State<PatientListPage> createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  final TextEditingController searchTextController = TextEditingController();
  final ValueNotifier<String> searchQueryNotifier = ValueNotifier('');
  late CollectionReference chatCollection;
  String? currentRole;

  @override
  void initState() {
    super.initState();
    _loadCurrentRole();
  }

  Future<void> _loadCurrentRole() async {
    final role = await Data.currentRole();
    setState(() {
      currentRole = role;
    });
  }

  @override
  void dispose() {
    searchTextController.dispose();
    searchQueryNotifier.dispose();
    super.dispose();
  }

  Users _createUserFromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Users(
      id: doc.id,
      name: data['name'] ?? '',
      cpr: data['cpr'] ?? '',
      dob: data['dob'] ?? '',
      role: data['role'] ?? '',
      gender: data['gender'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100, Colors.white],
            stops: [0.0, 0.8],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade500,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Patients",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (currentRole == 'admin' || currentRole == 'receptionist')
                    ElevatedButton.icon(
                      icon: Icon(Icons.add, color: Colors.blue.shade500),
                      label: Text(
                        'Add New',
                        style: TextStyle(color: Colors.blue.shade500),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 2,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () => context.go('/addpatient'),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchTextController,
                decoration: InputDecoration(
                  labelText: 'Search by CPR',
                  labelStyle: TextStyle(color: Colors.blue.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.blue.shade500, width: 2),
                  ),
                  suffixIcon: Icon(Icons.search, color: Colors.blue.shade400),
                  filled: true,
                  fillColor: Colors.white,
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
                        .where('role', isEqualTo: 'patient')
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
                        final data = doc.data() as Map<String, dynamic>;
                        String name =
                            (data['name'] ?? '').toString().toLowerCase();
                        String cpr =
                            (data['cpr'] ?? '').toString().toLowerCase();
                        return name.contains(searchQuery.toLowerCase()) ||
                            cpr.contains(searchQuery.toLowerCase());
                      }).toList();

                      if (filteredDocs.isEmpty) {
                        return const Center(
                            child: Text('No matching patients found.'));
                      }

                      return FutureBuilder<List<Map<String, dynamic>>>(
                        future: Future.wait(filteredDocs.map((doc) async {
                          try {
                            CollectionReference chatCollection =
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(doc.id)
                                    .collection('chat');

                            bool isSeen =
                                await isMessageSeen(chatCollection, 'patient');
                            return {
                              'doc': _createUserFromDoc(doc),
                              'isSeen': isSeen,
                            };
                          } catch (e) {
                            return {
                              'doc': _createUserFromDoc(doc),
                              'isSeen': false,
                            };
                          }
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
                            if (a['isSeen'] && !b['isSeen']) return -1;
                            if (!a['isSeen'] && b['isSeen']) return 1;
                            return 0;
                          });

                          return ListView.builder(
                            padding: EdgeInsets.all(16),
                            itemCount: sortedDocs.length,
                            itemBuilder: (context, index) {
                              final Users patientData =
                                  sortedDocs[index]['doc'];

                              return Card(
                                elevation: 3,
                                margin: EdgeInsets.only(bottom: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PatientDetailsPage(
                                          patient: patientData,
                                        ),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.blue.shade100,
                                          child: Text(
                                            patientData.name[0].toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.blue.shade700,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                patientData.name,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue.shade700,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'CPR: ${patientData.cpr}',
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              Text(
                                                'Phone: ${patientData.phone}',
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (currentRole == 'dentist' ||
                                            currentRole == 'patient')
                                          Container()
                                        else
                                          Icon(
                                            Icons.circle,
                                            color: sortedDocs[index]['isSeen']
                                                ? Colors.red
                                                : Colors.green,
                                          ),
                                      ],
                                    ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
