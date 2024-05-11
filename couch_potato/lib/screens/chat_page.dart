import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:couch_potato/network/database_handler.dart';
import 'package:couch_potato/classes/chatMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  // @override
  // Widget build(BuildContext context) {

    // User? user = FirebaseAuth.instance.currentUser;

    // String displayName = "null";

    // print("user:\n\n\n\n");
    // print(user);

    // if(user != null){
    //   displayName = user!.displayName ?? 'Unknown User';
    // }

  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  void _handleSubmit(String text) {
    _controller.clear();
    
    String senderId = "";
    String senderName = "";
    String senderPhoto = "";
    User? user = FirebaseAuth.instance.currentUser;
    if(user != null){
      senderId = user.uid;
      senderName = user.displayName!;
      senderPhoto = user.photoURL!;
    }
    
    ChatMessage message = ChatMessage(
      // Mocking the sender for now
      senderId: senderId,
      senderName: senderName,
      senderPhoto: senderPhoto,
      receiverId: "ze",
      receiverName: senderName,
      receiverPhoto: senderPhoto,
      text: text,
      timestamp: Timestamp.now()
    );
    setState(() {
      _messages.insert(0, message);
    });
    DatabaseHandler.sendMessage(message); //firestore
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return textBubble(chatMessage: _messages[index]);
            },
          ),
        ),
        Divider(height: 1.0),
        Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ],
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Color(0xFFF7981D)),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _controller,
                onSubmitted: _handleSubmit,
                decoration: InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _handleSubmit(_controller.text),
            ),
          ],
        ),
      ),
    );
  }
}

class textBubble extends StatelessWidget {

  final ChatMessage chatMessage;

  textBubble({required this.chatMessage});

  @override
  Widget build(BuildContext context) {

    String photoURL = "https://ichef.bbci.co.uk/news/976/cpsprodpb/16620/production/_91408619_55df76d5-2245-41c1-8031-07a4da3f313f.jpg.webp";
    String? url = FirebaseAuth.instance.currentUser?.photoURL;
    if(url != null){
      photoURL = url;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(photoURL)
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(chatMessage.senderName),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Text(chatMessage.text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

