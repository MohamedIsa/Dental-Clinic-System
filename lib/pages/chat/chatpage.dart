import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senior/functions/chat/seenmessage.dart';
import '../../../../functions/chat/getmessage.dart';
import '../../../../functions/chat/sendmessage.dart';
import '../../../../models/chat.dart';
import '../../../../utils/data.dart';
import 'messagebubble.dart';

class ChatPage extends StatefulWidget {
  final String patientId;
  final String senderId;

  ChatPage({required this.senderId, required this.patientId});

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
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Chat>>(
              stream: getMessages(chatCollection),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No messages yet.'));
                }

                var messages = snapshot.data!;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    bool isMe = message.senderId == Data.currentID;

                    return Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        MessageBubble(
                          sender: isMe ? 'You' : '',
                          text: message.text,
                          time: message.timestamp,
                          isMe: isMe,
                        ),
                        if (isMe && message.seen)
                          Text(
                            'Seen',
                            style: TextStyle(color: Colors.green, fontSize: 12),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) => sendMessage(
                        messageController, chatCollection, senderRole),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    await sendMessage(
                        messageController, chatCollection, senderRole);
                    messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
