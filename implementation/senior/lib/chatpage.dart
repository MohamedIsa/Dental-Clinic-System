import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final User user;
  final String otherUserId;
  final bool isAdmin;

  ChatPage({required Key key, required this.user, required this.otherUserId, required this.isAdmin}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      backgroundColor: Colors.blueGrey[600],
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('messages')
                  .where('participants', arrayContains: widget.user.uid)
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No messages found.'),
                  );
                }

                var messages = snapshot.data?.docs;
                List<Widget> messageWidgets = [];
                for (var message in messages!) {
                  final messageSender = message['sender'];
                  final messageText = message['text'];
                  final messageTime = (message['timestamp'] as Timestamp).toDate();

                  final messageWidget = MessageBubble(
                    sender: messageSender,
                    text: messageText,
                    time: messageTime,
                    isMe: widget.user.uid == messageSender,
                  );

                  messageWidgets.add(messageWidget);
                }

                return ListView(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  children: messageWidgets,
                );
              },
            ),
          ),
          if (!widget.isAdmin) // Only patients can send messages
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Enter your message...',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        _sendMessage(widget.user.uid);
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _sendMessage(String senderId) {
    String messageText = _messageController.text;
    _firestore.collection('messages').add({
      'text': messageText,
      'sender': senderId,
      'participants': [senderId, widget.otherUserId], // Include both sender and recipient
      'timestamp': Timestamp.now(),
    });
    _messageController.clear();
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({required this.sender, required this.text, required this.time, required this.isMe});

  final String sender;
  final String text;
  final DateTime time;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    String senderName = isMe ? 'You' : 'Patient'; 
    if (sender == 'admin') {
      senderName = 'Admin'; 
    }

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            senderName, // Use senderName instead of sender
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          SizedBox(height: 2),
          Text(
            DateFormat('HH:mm').format(time),
            style: TextStyle(fontSize: 10.0, color: Colors.grey),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            )
                : BorderRadius.only(
              topRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

