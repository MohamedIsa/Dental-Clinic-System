import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/chat.dart';

Stream<List<Chat>> getMessages(CollectionReference chatCollection) {
  return chatCollection.orderBy('timestamp').snapshots().map((querySnapshot) {
    return querySnapshot.docs
        .map((doc) => Chat.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  });
}
