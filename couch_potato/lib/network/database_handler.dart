import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couch_potato/classes/post.dart';
import 'package:couch_potato/classes/chatMessage.dart';
import 'package:couch_potato/classes/chat.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseHandler {
  static final db = FirebaseFirestore.instance;

  static Future<List<Post>> getPosts(int count) async {
    //TODO fetch n posts
    //TODO fetch only new posts
    List<Post> posts = [];

    await db.collection("posts").get().then((event) {
      debugPrint("Posts - ${event.docs.length}:");
      for (var item in event.docs) {
        debugPrint("${item.id} => ${item.data()}");

        Post post = Post(
          postId: item.id,
          username: item.data()['username'],
          createdAt: item.data()['createdAt'],
          profileImageUrl: item.data()['profileImageUrl'],
          description: item.data()['description'],
          mediaUrl: item.data()['mediaUrl'],
          mediaPlaceholder: item.data()['mediaPlaceholder'],
          fullLocation: item.data()['fullLocation'],
          category: item.data()['category'],
        );

        posts.add(post);
      }
    });

    return posts;
  }

  static Future<void> publishPost(Post post) async {
    await db.collection("posts").add({
      'username': post.username,
      'createdAt': post.createdAt,
      'profileImageUrl': post.profileImageUrl,
      'description': post.description,
      'mediaUrl': post.mediaUrl,
      'mediaPlaceholder': post.mediaPlaceholder,
      'fullLocation': post.fullLocation,
      'category': post.category,
    });
  }

  static Future<Post> getSinglePost(String postId) async {
    late Post post;

    await db.collection("posts").doc(postId).get().then((event) {
      debugPrint("Post - ${event.id}: ${event.data()}");

      post = Post(
        postId: event.id,
        username: event.data()!['username'],
        createdAt: event.data()!['createdAt'],
        profileImageUrl: event.data()!['profileImageUrl'],
        description: event.data()!['description'],
        mediaUrl: event.data()!['mediaUrl'],
        mediaPlaceholder: event.data()!['mediaPlaceholder'],
        fullLocation: event.data()!['fullLocation'],
        category: event.data()!['category'],
      );
    });

    return post;
  }

  static Future<List<Chat>> getChats(String userId) async {
    List<Chat> chats = [];

    await db.collection("chats").where('user1Id', isEqualTo: userId).get().then((event) {
      debugPrint("Chats - ${event.docs.length}:");
      for (var item in event.docs) {
        debugPrint("${item.id} => ${item.data()}");

        Chat chat = Chat(
          id: item.id,
          userId: item.data()['user2Id'],
          userName: item.data()['user2Name'],
          userPhoto: item.data()['user2Photo'],
        );

        chats.add(chat);
      }
    });

    await db.collection("chats").where('user2Id', isEqualTo: userId).get().then((event) {
      debugPrint("Chats - ${event.docs.length}:");
      for (var item in event.docs) {
        debugPrint("${item.id} => ${item.data()}");

        Chat chat = Chat(
          id: item.id,
          userId: item.data()['user1Id'],
          userName: item.data()['user1Name'],
          userPhoto: item.data()['user1Photo'],
        );

        chats.add(chat);
      }
    });

    return chats;
  }

  static Future<void> sendMessage(ChatMessage message) async {
    await db.collection("messages").add({
      'chatId': message.chatId,
      'senderId': message.senderId,
      'text': message.text,
      'timestamp': message.timestamp,
    });
  }
}
