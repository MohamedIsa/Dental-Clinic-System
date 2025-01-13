import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Data {
  static Future<String> apiUrl() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('api').get();
    String api = querySnapshot.docs.first.get('api');
    return api;
  }

  static String currentID = FirebaseAuth.instance.currentUser!.uid;
}
