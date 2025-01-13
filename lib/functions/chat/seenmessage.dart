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

Future<bool> isMessageSeen(CollectionReference chatCollection) async {
  final currentUserId = Data.currentID;
  final querySnapshot = await chatCollection
      .where('senderId', isNotEqualTo: currentUserId)
      .where('seen', isEqualTo: false)
      .get();
  return querySnapshot.docs.isNotEmpty;
}
