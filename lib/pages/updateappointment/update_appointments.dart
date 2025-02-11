import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../const/app_colors.dart';
import '../../utils/data.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class UpdateAppointments extends StatefulWidget {
  const UpdateAppointments({super.key});

  @override
  State<UpdateAppointments> createState() => _UpdateAppointmentsState();
}

class _UpdateAppointmentsState extends State<UpdateAppointments> {
  late Stream<QuerySnapshot> _appointmentsStream;

  @override
  void initState() {
    super.initState();
    Data.checkUserAndNavigate(context);
    _initializeAppointmentsStream();
  }

  void _initializeAppointmentsStream() {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _appointmentsStream = FirebaseFirestore.instance
        .collection('users')
        .doc(Data.currentID)
        .collection('appointments')
        .where('patientId', isEqualTo: Data.currentID)
        .where('date', isGreaterThan: today)
        .orderBy('date')
        .orderBy('time')
        .snapshots();
  }

  Future<void> _deleteAppointment(String appointmentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(Data.currentID)
          .collection('appointments')
          .doc(appointmentId)
          .delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete appointment')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'My Appointments',
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
                  'No upcoming appointments',
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
                final date = (data['date'] as Timestamp).toDate();
                final time = (data['time'] as Timestamp).toDate();

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(data['dentistId'])
                      .get(),
                  builder: (context, dentistSnapshot) {
                    if (dentistSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Card(
                        child: ListTile(
                          title: Text('Loading...'),
                        ),
                      );
                    }

                    final dentistData =
                        dentistSnapshot.data?.data() as Map<String, dynamic>?;
                    final dentistName =
                        dentistData?['name'] ?? 'Unknown Doctor';

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
                              'Date: ${date.day}/${date.month}/${date.year}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Time: ${time.hour}:00',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                context.go(
                                  '/booking',
                                  extra: {
                                    'isEditing': true,
                                    'appointmentId': appointment.id,
                                    'dentistId': data['dentistId'],
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Appointment'),
                                  content: const Text(
                                    'Are you sure you want to delete this appointment?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _deleteAppointment(appointment.id);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              ),
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
