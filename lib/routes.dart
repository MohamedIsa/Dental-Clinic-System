import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'const/app_colors.dart';
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
      GoRoute(path: '/', builder: (context, state) => const Loading()),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
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
      GoRoute(path: '/dashboard', builder: (context, state) => Dashboard()),
      GoRoute(path: '/settings', builder: (context, state) => SettingsScreen()),
      GoRoute(
        path: '/addstaff',
        builder: (context, state) =>
            Add(title: 'Add New Staff', show: true, add: 'Add Staff'),
      ),
      GoRoute(path: '/patients', builder: (context, state) => PatientScreen()),
      GoRoute(
        path: '/addpatient',
        builder: (context, state) =>
            Add(title: 'Add New Patient', show: false, add: 'Add Patient'),
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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          primary: AppColors.mainBlueColor,
          secondary: AppColors.accentColor,
          surface: AppColors.whiteColor,
        ),
        scaffoldBackgroundColor: AppColors.backColor,
        textTheme: GoogleFonts.ralewayTextTheme(Theme.of(context).textTheme),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: AppColors.whiteColor,
          foregroundColor: AppColors.blueDarkColor,
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: CardThemeData(
          color: AppColors.whiteColor,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.borderColor),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.whiteColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.mainBlueColor,
              width: 1.4,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainBlueColor,
            foregroundColor: AppColors.whiteColor,
            elevation: 0,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
