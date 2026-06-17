import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';
import 'package:senior/routes.dart';
import 'providers/home_navbar.dart';
import 'providers/patient_navbar.dart';
import 'providers/side_menu_provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeNavBarProvider()),
        ChangeNotifierProvider(create: (_) => PatientNavBarProvider()),
        ChangeNotifierProvider(create: (_) => SideMenuProvider()),
      ],
      child: Routes(),
    ),
  );
}
