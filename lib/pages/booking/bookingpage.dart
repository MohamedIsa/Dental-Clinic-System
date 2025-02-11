import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../const/app_colors.dart';
import '../../functions/booking/bookappointment.dart';
import '../../utils/data.dart';
import '../../utils/popups.dart';
import '../widgets/selections/date_selection.dart';
import '../widgets/selections/dentist_selection.dart';
import '../widgets/selections/time_selection.dart';
import '../widgets/selections/bookingdetails.dart';

class BookingPage extends StatefulWidget {
  final String title;
  final String buttonText;
  final bool isFacility;

  const BookingPage({
    super.key,
    required this.title,
    required this.buttonText,
    this.isFacility = false,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String selectedDentistId = '';
  String selectedDentistFirstName = '';
  DateTime selectedDate = DateTime.now();
  int selectedHour = -1;
  bool showDentistSelection = false;
  bool showContainer = false;
  bool showTime = false;
  bool showReview = false;

  // For facility booking
  final TextEditingController _cprController = TextEditingController();
  String? verifiedPatientId;
  bool isVerifying = false;

  Future<void> _verifyPatient() async {
    if (_cprController.text.length != 9) {
      showErrorDialog(context, 'CPR must be exactly 9 digits');
      return;
    }

    setState(() => isVerifying = true);

    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('cpr', isEqualTo: _cprController.text)
          .limit(1)
          .get();

      if (result.docs.isEmpty) {
        if (!mounted) return;
        showErrorDialog(context, 'No patient found with this CPR');
        return;
      }

      setState(() {
        verifiedPatientId = result.docs.first.id;
        showDentistSelection = true;
      });
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, 'Error verifying patient: $e');
    } finally {
      setState(() => isVerifying = false);
    }
  }

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
      selectedHour = -1;
      showReview = false;
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
      if (widget.isFacility && verifiedPatientId == null) {
        showErrorDialog(context, 'Please verify patient first');
        return;
      }

      bookAppointment(
        context,
        widget.isFacility,
        selectedDentistId,
        selectedDate,
        selectedHour,
        widget.isFacility ? verifiedPatientId! : Data.currentID!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.title,
          style: const TextStyle(
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
            colors: [AppColors.primaryColor, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16.0 : screenSize.width * 0.1,
            vertical: 24.0,
          ),
          child: Column(
            children: [
              if (widget.isFacility && !showDentistSelection)
                _buildBookingStep(
                  context,
                  isSmallScreen,
                  title: '1. Verify Patient',
                  content: _buildPatientVerification(),
                ),
              if (!widget.isFacility || showDentistSelection) ...[
                _buildBookingStep(
                  context,
                  isSmallScreen,
                  title: widget.isFacility
                      ? '2. Select Dentist'
                      : '1. Select Dentist',
                  content: DentistSelection(
                    onDentistSelected: onDentistSelected,
                  ),
                ),
                if (showContainer)
                  _buildBookingStep(
                    context,
                    isSmallScreen,
                    title:
                        widget.isFacility ? '3. Select Date' : '2. Select Date',
                    content: DateSelection(
                      selectedDentistId: selectedDentistId,
                      onDateSelected: onDateSelected,
                    ),
                  ),
                if (showTime)
                  _buildBookingStep(
                    context,
                    isSmallScreen,
                    title:
                        widget.isFacility ? '4. Select Time' : '3. Select Time',
                    content: TimeSelection(
                      selectedDentistId: selectedDentistId,
                      selectedDate: selectedDate,
                      onTimeSelected: onTimeSelected,
                    ),
                  ),
                if (showReview) ...[
                  _buildBookingStep(
                    context,
                    isSmallScreen,
                    title: widget.isFacility
                        ? '5. Review Details'
                        : '4. Review Details',
                    content: AppointmentDetails(
                      selectedDentistFirstName: selectedDentistFirstName,
                      selectedDate: selectedDate,
                      selectedHour: selectedHour,
                      selectedDentistId: selectedDentistId,
                      showContainer: showContainer,
                      showTime: showTime,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: booking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      widget.buttonText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientVerification() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _cprController,
            keyboardType: TextInputType.number,
            maxLength: 9,
            decoration: InputDecoration(
              labelText: 'Patient CPR',
              hintText: 'Enter 9-digit CPR',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              counterText: '',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: isVerifying ? null : _verifyPatient,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isVerifying
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Verify Patient'),
          ),
        ],
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

  @override
  void dispose() {
    _cprController.dispose();
    super.dispose();
  }
}
