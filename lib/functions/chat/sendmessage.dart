import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/chatmessage.dart';
import '../../utils/data.dart';

Future<void> sendMessage(TextEditingController controller,
    CollectionReference chatCollection) async {
  final text = controller.text.trim();
  if (text.isEmpty) return;

  final newMessage = ChatMessage(
    senderId: Data.currentID,
    text: text,
    timestamp: DateTime.now(),
    seen: false,
  );

  await chatCollection.add(newMessage.toMap());
  controller.clear();
}
