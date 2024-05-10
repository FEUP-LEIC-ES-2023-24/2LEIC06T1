import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  @override
  Widget build(BuildContext context) {

  User? user = FirebaseAuth.instance.currentUser;

  String displayName = "null";

  print("user:\n\n\n\n");
  print(user);

  if(user != null){
    displayName = user!.displayName ?? 'Unknown User';
  }

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo'),
      ),
      body: Center(
        child: Text(
          displayName,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}