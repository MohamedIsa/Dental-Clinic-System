import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/data.dart';

Future<void> markMessagesAsSeen(CollectionReference chatCollection) async {
  final currentUserId = Data.currentID;

  final querySnapshot = await chatCollection
      .where('senderId', isNotEqualTo: currentUserId)
      .where('seen', isEqualTo: false)
      .get();

  for (var doc in querySnapshot.docs) {
    await doc.reference.update({'seen': true});
  }
}

Future<bool> isMessageSeen(
    CollectionReference chatCollection, String currentRole) async {
  final currentUserId = Data.currentID;

  Query query = chatCollection
      .where('senderId', isNotEqualTo: currentUserId)
      .where('seen', isEqualTo: false);

  if (currentRole == 'patient') {
    query = query.where('senderRole', whereIn: ['admin', 'receptionist']);
  } else if (currentRole == 'admin' || currentRole == 'receptionist') {
    query = query.where('senderRole', isEqualTo: 'patient');
  }

  final querySnapshot = await query.get();
  return querySnapshot.docs.isNotEmpty;
}
