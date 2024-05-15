import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:couch_potato/network/database_handler.dart';
import 'package:couch_potato/classes/chatMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couch_potato/classes/chat.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  Chat? chat;


  void _handleSubmit(String text) {
    _controller.clear();
    
    String senderId = "";
    User? user = FirebaseAuth.instance.currentUser;
    if(user != null){
      senderId = user.uid;
    }

    String chatId = "";
    if(chat != null) chatId = chat!.id;
    
    ChatMessage message = ChatMessage(
      chatId: chatId,
      senderId: senderId,
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

    chat ??= ModalRoute.of(context)!.settings.arguments as Chat?;
    String username = "no username";

    if(chat?.userName != null) username = chat!.userName;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back when the back arrow is pressed
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(chat?.userPhoto ?? ''),
            ),
            SizedBox(width: 8), // Add spacing between the image and the title
            Text(username),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessagesStream(chat),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      )
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
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final List<ChatMessage> messages = [];
        snapshot.data!.docs.forEach((doc) {
          final data = doc.data() as Map<String, dynamic>?; // Explicitly cast to Map<String, dynamic> or nullable
          if (data != null) {
            messages.add(ChatMessage.fromMap(data));
          }
        });
        
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

class TextBubble extends StatelessWidget {

  final ChatMessage chatMessage;

  TextBubble({required this.chatMessage});

  @override
  Widget build(BuildContext context) {

    print("\n\n text booble\n\n");

    String photoURL = "https://ichef.bbci.co.uk/news/976/cpsprodpb/16620/production/_91408619_55df76d5-2245-41c1-8031-07a4da3f313f.jpg.webp";
    String? url = FirebaseAuth.instance.currentUser?.photoURL;
    if(url != null){
      photoURL = url;
    }

    DateTime date = chatMessage.timestamp.toDate();
    String hours = date.hour.toString();
    String minutes = (date.minute < 10 ? "0" : "") + date.minute.toString();

    bool amISender = chatMessage.senderId == FirebaseAuth.instance.currentUser!.uid;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: amISender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: amISender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              //Text(amISender ? 'Me' : 'ze'),
              Container(
                margin: EdgeInsets.only(top: 0.0, left: amISender ? 0 : 5, right: amISender ?  5.0 : 0),
                padding: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: amISender ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                    bottomLeft: amISender ? Radius.circular(15.0) : Radius.circular(0.0),
                    bottomRight: amISender ? Radius.circular(0.0) : Radius.circular(15.0),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children:[
                    Container(
                      padding: EdgeInsets.all(8.0),
                      //padding: EdgeInsets.only(right: 5.0),
                      child: Text(
                        chatMessage.text,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(
                      hours + ':' + minutes,
                      style: TextStyle(color: Colors.white, fontSize: 10),
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

