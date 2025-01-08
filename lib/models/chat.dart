import 'package:cloud_firestore/cloud_firestore.dart';

import 'chatmessage.dart';

class Chat {
  String patientId;
  List<ChatMessage> messages;
  DateTime lastUpdated;

  Chat({
    required this.patientId,
    required this.messages,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'messages': messages.map((message) => message.toMap()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  static Chat fromMap(String patientId, Map<String, dynamic> map) {
    var messages = (map['messages'] as List)
        .map((messageMap) => ChatMessage.fromMap(messageMap))
        .toList();

    return Chat(
      patientId: patientId,
      messages: messages,
      lastUpdated: DateTime.parse(map['lastUpdated']),
    );
  }

  void addMessage(ChatMessage message) {
    messages.add(message);
    lastUpdated = DateTime.now();
  }

  static CollectionReference getUserChatCollection(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chat');
  }

  static DocumentReference getChatMessageDocument(
      String userId, String messageId) {
    return getUserChatCollection(userId).doc(messageId);
  }

  static Future<List<ChatMessage>> getPatientChatMessages(String userId) async {
    var chatCollection = getUserChatCollection(userId);
    var snapshot = await chatCollection.orderBy('timestamp').get();
    return snapshot.docs
        .map((doc) => ChatMessage.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> addMessageToPatientChat(
      String userId, ChatMessage message) async {
    await getUserChatCollection(userId).add(message.toMap());
  }
}
