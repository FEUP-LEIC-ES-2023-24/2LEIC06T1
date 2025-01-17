import 'package:couch_potato/screens/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:couch_potato/network/database_handler.dart';
import 'package:couch_potato/classes/chat.dart';
import 'package:couch_potato/modules/page_fault_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Chat>>(
      future: DatabaseHandler.getChats(FirebaseAuth.instance.currentUser!.uid),
      builder: (BuildContext context, AsyncSnapshot<List<Chat>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While data is loading, show a loading indicator or placeholder
          return Center(
              child: LoadingAnimationWidget.waveDots(
            color: Colors.grey.shade200,
            size: 100,
          ));
        } else if (snapshot.hasError) {
          // If an error occurs during data fetching, display an error message
          return const Center(child: Text('Error loading data'));
        } else {
          // Once data is loaded successfully, display the list of chats
          List<Chat> chats = snapshot.data!;

          if (chats.isEmpty) {
            return Transform.translate(
              offset: const Offset(0.0, -150.0),
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: PageFaultScreen(
                  imagePath: 'assets/app_icon.png',
                  title: 'No chats available',
                  description: "Acquire an item through a post to contact the owner",
                ),
              ),
            );
          }

          return Scaffold(
            appBar: null,
            body: ListView.separated(
              itemCount: chats.length,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  color: Colors.black,
                  thickness: 1.0,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return ChatElementWidget(chat: chats[index]);
              },
            ),
          );
        }
      },
    );
  }
}

class ChatElementWidget extends StatelessWidget {
  final Chat chat;

  const ChatElementWidget({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(chat.userPhoto),
      ),
      title: Text(chat.userName),
      subtitle: const Text('tap to view messages'), // You can add message text here
      onTap: () {
        //Material page route to navigate to the chat page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(chat: chat),
          ),
        );
      },
    );
  }
}
