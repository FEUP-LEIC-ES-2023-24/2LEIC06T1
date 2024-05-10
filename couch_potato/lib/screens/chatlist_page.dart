import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {

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
      appBar: null,
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