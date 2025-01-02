import 'package:flutter/material.dart';

import '../models/navbaritem.dart';

final List<NavBarItem> navItemsp = [
  NavBarItem(
    icon: Icons.home,
    label: 'Home',
    route: '/patientDashboard',
  ),
  NavBarItem(
    icon: Icons.calendar_today,
    label: 'Book Appointment',
    route: '/bookingm',
  ),
  NavBarItem(
    icon: Icons.history,
    label: 'Appointment History',
    route: '/appointmenthistory',
  ),
  NavBarItem(
    icon: Icons.person,
    label: 'Update Account',
    route: '/update',
  ),
  NavBarItem(
    icon: Icons.edit,
    label: 'Edit Appointment',
    route: '/editappointment',
  ),
];

final List<NavBarItem> HomeNavItems = [
  NavBarItem(icon: Icons.home, label: 'Home', route: '/home'),
  NavBarItem(
      icon: Icons.medical_services, label: 'Services', route: '/services'),
  NavBarItem(icon: Icons.info, label: 'About Us', route: '/about'),
  NavBarItem(icon: Icons.login, label: 'Login', route: '/login'),
  NavBarItem(icon: Icons.app_registration, label: 'Sign Up', route: '/signup'),
];
