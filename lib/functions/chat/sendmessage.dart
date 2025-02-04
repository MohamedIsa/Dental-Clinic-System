import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/chat.dart';
import '../../utils/data.dart';

Future<void> sendMessage(TextEditingController controller,
    CollectionReference chatCollection, String role) async {
  final text = controller.text.trim();
  if (text.isEmpty) return;

  final newMessage = Chat(
    senderId: Data.currentID!,
    text: text,
    timestamp: DateTime.now(),
    seen: false,
    role: role,
  );

  await chatCollection.add(newMessage.toMap());
  controller.clear();
}
