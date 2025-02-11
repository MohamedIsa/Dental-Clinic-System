import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'const/loading.dart';
import 'pages/auth/AuthScreen.dart';
import 'pages/booking/bookingpage.dart';
import 'pages/facultyhome/dashboard.dart';
import 'pages/history/appointments_history.dart';
import 'pages/home/home.dart';
import 'pages/patients/patient_screen.dart';
import 'pages/phome/phome.dart';
import 'pages/settings/settings_screen.dart';
import 'pages/staff/addstaff/add.dart';
import 'pages/treatment/add_treatment.dart';
import 'pages/treatment/treatment_record_screen.dart';
import 'pages/updateaccount/updateacount.dart';
import 'pages/updateappointment/update_appointments.dart';

class Routes extends StatelessWidget {
  Routes({super.key});
  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Loading(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const AuthScreen(
          isSignUp: false,
          isCompleteDetails: false,
          isForgotPassword: false,
        ),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const AuthScreen(
          isSignUp: true,
          isCompleteDetails: false,
          isForgotPassword: false,
        ),
      ),
      GoRoute(
        path: '/complete',
        builder: (context, state) => const AuthScreen(
          isSignUp: false,
          isCompleteDetails: true,
          isForgotPassword: false,
        ),
      ),
      GoRoute(
        path: '/forgot',
        builder: (context, state) => const AuthScreen(
          isSignUp: false,
          isCompleteDetails: false,
          isForgotPassword: true,
        ),
      ),
      GoRoute(
        path: '/patientDashboard',
        builder: (context, state) => WelcomePage(),
      ),
      GoRoute(
        path: '/update',
        builder: (context, state) => UpdateAccountPage(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => Dashboard(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => SettingsScreen(),
      ),
      GoRoute(
        path: '/addstaff',
        builder: (context, state) => Add(
          title: 'Add New Staff',
          show: true,
          add: 'Add Staff',
        ),
      ),
      GoRoute(
        path: '/patients',
        builder: (context, state) => PatientScreen(),
      ),
      GoRoute(
        path: '/addpatient',
        builder: (context, state) => Add(
          title: 'Add New Patient',
          show: false,
          add: 'Add Patient',
        ),
      ),
      GoRoute(
        path: '/booking',
        builder: (context, state) => BookingPage(
          title: 'Book Appointment',
          buttonText: 'Confirm Booking',
        ),
      ),
      GoRoute(
        path: '/updateappointment',
        builder: (context, state) => UpdateAppointments(),
      ),
      GoRoute(
        path: '/appointmenthistory',
        builder: (context, state) => AppointmentsHistory(),
      ),
      GoRoute(
        path: '/treatment',
        builder: (context, state) => TreatmentRecordScreen(),
      ),
      GoRoute(
        path: '/addtreatment',
        builder: (context, state) => AddTreatmentPage(),
      ),
      GoRoute(
        path: '/facilitybooking',
        builder: (context, state) => BookingPage(
          title: 'Book Facility Appointment',
          buttonText: 'Confirm Booking',
          isFacility: true,
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
