import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/chatmessage.dart';

Stream<List<ChatMessage>> getMessages(CollectionReference chatCollection) {
  return chatCollection.orderBy('timestamp').snapshots().map((querySnapshot) {
    return querySnapshot.docs
        .map((doc) => ChatMessage.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  });
}
