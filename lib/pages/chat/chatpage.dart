import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../const/app_colors.dart';
import '../../functions/chat/seenmessage.dart';
import '../../functions/chat/getmessage.dart';
import '../../functions/chat/sendmessage.dart';
import '../../models/chat.dart';
import '../../utils/data.dart';
import 'messagebubble.dart';

class ChatPage extends StatefulWidget {
  final String patientId;
  final String senderId;

  const ChatPage({super.key, required this.senderId, required this.patientId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  late CollectionReference chatCollection;
  String senderRole = Data.currentRole.toString();

  @override
  void initState() {
    super.initState();
    chatCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.patientId)
        .collection('chat');
    markMessagesAsSeen(chatCollection);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Chat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Chat>>(
                stream: getMessages(chatCollection),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No messages yet.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }

                  var messages = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var message = messages[index];
                      bool isMe = message.senderId == Data.currentID;

                      return MessageBubble(
                        sender: isMe ? 'You' : '',
                        text: message.text,
                        time: message.timestamp,
                        isMe: isMe,
                        isSeen: message.seen,
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type your message...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                          onSubmitted: (value) => sendMessage(
                            messageController,
                            chatCollection,
                            senderRole,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    onPressed: () async {
                      await sendMessage(
                        messageController,
                        chatCollection,
                        senderRole,
                      );
                      messageController.clear();
                    },
                    backgroundColor: AppColors.primaryColor,
                    elevation: 2,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
