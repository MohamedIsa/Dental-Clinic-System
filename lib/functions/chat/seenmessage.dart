import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> markMessagesAsSeen(CollectionReference chatCollection) async {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  final querySnapshot = await chatCollection
      .where('senderId', isNotEqualTo: currentUserId)
      .where('seen', isEqualTo: false)
      .get();

  for (var doc in querySnapshot.docs) {
    await doc.reference.update({'seen': true});
  }
}

//create a function to check if the message is seen or not similar to the query above to check if the current uid is the same as the sender id and the message is not seen
Future<bool> isMessageSeen(CollectionReference chatCollection) async {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final querySnapshot = await chatCollection
      .where('senderId', isNotEqualTo: currentUserId)
      .where('seen', isEqualTo: false)
      .get();
  return querySnapshot.docs.isNotEmpty;
}
