import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:couch_potato/network/database_handler.dart';
import 'package:couch_potato/classes/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couch_potato/classes/chat.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;
  const ChatPage({super.key, required this.chat});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  void _handleSubmit(String text) {
    _controller.clear();

    String senderId = "";
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      senderId = user.uid;
    }

    String chatId = widget.chat.id;

    ChatMessage message = ChatMessage(chatId: chatId, senderId: senderId, text: text, timestamp: Timestamp.now());
    setState(() {
      _messages.insert(0, message);
    });
    DatabaseHandler.sendMessage(message); //firestore
  }

  @override
  Widget build(BuildContext context) {
    String username = widget.chat.userName;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back when the back arrow is pressed
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.chat.userPhoto),
            ),
            const SizedBox(width: 8), // Add spacing between the image and the title
            Text(username),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessagesStream(widget.chat),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesStream(Chat? chat) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .where("chatId", isEqualTo: chat!.id)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final List<ChatMessage> messages = [];
        for (var doc in snapshot.data!.docs) {
          final data = doc.data() as Map<String, dynamic>?; // Explicitly cast to Map<String, dynamic> or nullable
          if (data != null) {
            messages.add(ChatMessage.fromMap(data));
          }
        }

        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return TextBubble(chatMessage: messages[index]);
          },
        );
      },
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: const IconThemeData(color: Color(0xFFF7981D)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _controller,
                onTapOutside: (PointerDownEvent p) {
                  FocusScope.of(context).unfocus();
                },
                onSubmitted: _handleSubmit,
                decoration: const InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _handleSubmit(_controller.text),
            ),
          ],
        ),
      ),
    );
  }
}

class TextBubble extends StatelessWidget {
  final ChatMessage chatMessage;

  const TextBubble({super.key, required this.chatMessage});

  @override
  Widget build(BuildContext context) {
    debugPrint("\n\n text booble\n\n");

    DateTime date = chatMessage.timestamp.toDate();
    String hours = date.hour.toString();
    String minutes = (date.minute < 10 ? "0" : "") + date.minute.toString();

    bool amISender = chatMessage.senderId == FirebaseAuth.instance.currentUser!.uid;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: amISender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: amISender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 0.0, left: amISender ? 0 : 5, right: amISender ? 5.0 : 0),
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: amISender ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(15.0),
                    topRight: const Radius.circular(15.0),
                    bottomLeft: amISender ? const Radius.circular(15.0) : const Radius.circular(0.0),
                    bottomRight: amISender ? const Radius.circular(0.0) : const Radius.circular(15.0),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      //padding: EdgeInsets.only(right: 5.0),
                      child: Text(
                        chatMessage.text,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(
                      '$hours:$minutes',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
