import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../const/app_colors.dart';
import 'package:logger/logger.dart';

class TodayAppointmentPage extends StatelessWidget {
  TodayAppointmentPage({super.key});

  final logger = Logger();

  @override
  Widget build(BuildContext context) {
    logger.d('Building TodayAppointmentPage');
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade50, Colors.white],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Today\'s Schedule',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .where('date',
                      isEqualTo: DateTime.now().toString().split(' ')[0])
                  .orderBy('time', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  logger.d('Loading appointments...');
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  logger.e('Error loading appointments: ${snapshot.error}');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          'Error loading appointments',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  logger.i('No appointments found for today');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_available,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No appointments scheduled for today',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                logger.i(
                    'Found ${snapshot.data!.docs.length} appointments for today');
                return Card(
                  margin: EdgeInsets.all(16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.separated(
                    padding: EdgeInsets.all(16),
                    itemCount: snapshot.data!.docs.length,
                    separatorBuilder: (context, index) => Divider(height: 1),
                    itemBuilder: (context, index) {
                      final appointment = snapshot.data!.docs[index];
                      final data = appointment.data() as Map<String, dynamic>;
                      logger.d(
                          'Building appointment item for time: ${data['time']}');
                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(data['patientId'])
                            .get(),
                        builder: (context, patientSnapshot) {
                          if (!patientSnapshot.hasData) {
                            logger.w(
                                'Patient data not found for ID: ${data['patientId']}');
                            return SizedBox.shrink();
                          }

                          final patientData = patientSnapshot.data!.data()
                              as Map<String, dynamic>;
                          final patientName =
                              patientData['name'] ?? 'Unknown Patient';
                          logger.d('Retrieved patient name: $patientName');

                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16),
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primaryColor,
                                child: Text(
                                  '${data['time']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                patientName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text(
                                    'Time: ${data['time']}:00',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Scheduled',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
