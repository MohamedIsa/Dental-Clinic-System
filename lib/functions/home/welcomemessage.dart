import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

final Logger _logger = Logger();
String welcomeMessage = '';

Future<String> fetchWelcomeMessage() async {
  try {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('welcome').limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      welcomeMessage = snapshot.docs.first['message'] ?? '';
    }
  } catch (error) {
    welcomeMessage = '';
  }
  return welcomeMessage;
}
