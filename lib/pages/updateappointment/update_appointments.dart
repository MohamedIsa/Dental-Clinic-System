// the update appointment page is just accessing the booking page bt with different data here is the code for the book appointments
/**
import 'package:flutter/material.dart';
import '../../const/app_colors.dart';
import '../../functions/booking/bookappointment.dart';
import '../../utils/data.dart';
import '../../utils/popups.dart';
import '../widgets/selections/date_selection.dart';
import '../widgets/selections/dentist_selection.dart';
import '../widgets/selections/time_selection.dart';
import '../widgets/selections/bookingdetails.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String selectedDentistId = '';
  String selectedDentistFirstName = '';
  DateTime selectedDate = DateTime.now();
  int selectedHour = -1;
  bool showContainer = false;
  bool showTime = false;
  bool showReview = false;

  void onDentistSelected(String dentistId, String dentistFirstName) {
    setState(() {
      selectedDentistId = dentistId;
      selectedDentistFirstName = dentistFirstName;
      showContainer = true;
    });
  }

  void onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
      showTime = true;
    });
  }

  void onTimeSelected(int hour) {
    setState(() {
      selectedHour = hour;
      showReview = true;
    });
  }

  void booking() {
    if (selectedDentistId.isNotEmpty && selectedHour != -1) {
      bookAppointment(
        context,
        selectedDentistId,
        selectedDate,
        selectedHour,
        Data.currentID!,
      );
    } else {
      showErrorDialog(context, 'Please select a dentist, date, and time.');
    }
  }

  @override
  void initState() {
    Data.checkUserAndNavigate(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Book Appointment',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16.0 : screenSize.width * 0.1,
              vertical: 24.0,
            ),
            child: Column(
              children: [
                _buildBookingStep(
                  context,
                  isSmallScreen,
                  title: '1. Select Your Dentist',
                  content: DentistSelection(
                    onDentistSelected: onDentistSelected,
                  ),
                ),
                if (showContainer)
                  _buildBookingStep(
                    context,
                    isSmallScreen,
                    title: '2. Choose Available Date',
                    content: DateSelection(
                      selectedDentistId: selectedDentistId,
                      onDateSelected: onDateSelected,
                    ),
                  ),
                if (showTime)
                  _buildBookingStep(
                    context,
                    isSmallScreen,
                    title: '3. Pick Preferred Time',
                    content: TimeSelection(
                      selectedDentistId: selectedDentistId,
                      selectedDate: selectedDate,
                      onTimeSelected: onTimeSelected,
                    ),
                  ),
                if (showReview)
                  _buildBookingStep(
                    context,
                    isSmallScreen,
                    title: '4. Review Details',
                    content: AppointmentDetails(
                      selectedDentistFirstName: selectedDentistFirstName,
                      selectedDate: selectedDate,
                      selectedHour: selectedHour,
                      selectedDentistId: selectedDentistId,
                      showContainer: showContainer,
                      showTime: showTime,
                    ),
                  ),
                const SizedBox(height: 32),
                SizedBox(
                  width:
                      isSmallScreen ? double.infinity : screenSize.width * 0.3,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: booking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'Confirm Booking',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingStep(
    BuildContext context,
    bool isSmallScreen, {
    required String title,
    required Widget content,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: content,
            ),
          ),
        ],
      ),
    );
  }
}

 */
// now it should just create a list of the avialiable appintments that the patient booked and it is still valid to edit (means it is time did not end yet) or to have the ability to delete the appointment

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
