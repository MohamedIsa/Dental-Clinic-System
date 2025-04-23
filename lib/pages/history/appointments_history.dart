import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../utils/data.dart';
import '../../const/app_colors.dart';

class AppointmentsHistory extends StatefulWidget {
  const AppointmentsHistory({super.key});

  @override
  State<AppointmentsHistory> createState() => _AppointmentsHistoryState();
}

class _AppointmentsHistoryState extends State<AppointmentsHistory> {
  late Stream<QuerySnapshot> _appointmentsStream;

  @override
  void initState() {
    Data.checkUserAndNavigate(context);
    super.initState();
    _initializeAppointmentsStream();
  }

  void _initializeAppointmentsStream() {
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    _appointmentsStream = FirebaseFirestore.instance
        .collection('users')
        .doc(Data.currentID)
        .collection('appointments')
        .where('patientId', isEqualTo: Data.currentID)
        .where('date', isLessThan: today.toString().split(' ')[0])
        .orderBy('date', descending: true)
        .orderBy('time', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Appointments History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor,
              Colors.white,
            ],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _appointmentsStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'No past appointments',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final appointment = snapshot.data!.docs[index];
                final data = appointment.data() as Map<String, dynamic>;
                final date = data['date'] as String;
                final time = data['time'] as int;

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(data['dentistId'])
                      .get(),
                  builder: (context, dentistSnapshot) {
                    if (dentistSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Card(
                        child: Center(
                          child: SpinKitPulse(
                            color: Colors.blue,
                            size: 40.0,
                          ),
                        ),
                      );
                    }

                    final dentistData =
                        dentistSnapshot.data?.data() as Map<String, dynamic>?;
                    final dentistName =
                        dentistData?['name'] ?? 'Unknown Doctor';

                    final dateParts = date.split('-');
                    final formattedDate =
                        '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}';

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          'Dr. $dentistName',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              'Date: $formattedDate',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Time: $time:00',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
