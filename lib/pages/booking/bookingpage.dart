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
  final String title;
  final String buttonText;
  const BookingPage({super.key, required this.title, required this.buttonText});

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
        title: Text(
          widget.title,
          style: const TextStyle(
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
                    child: Text(
                      widget.buttonText,
                      style: const TextStyle(
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
