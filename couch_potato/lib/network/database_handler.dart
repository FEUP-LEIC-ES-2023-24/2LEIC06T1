import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couch_potato/classes/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class DatabaseHandler {
  static final db = FirebaseFirestore.instance;

  static final storageRef = FirebaseStorage.instance.ref();

  static Future<void> checkFirebaseAuth() async {
    debugPrint("Checking Firebase Auth: ${FirebaseAuth.instance.currentUser}");
    if (FirebaseAuth.instance.currentUser == null) {
      try {
        GoogleSignInAccount? googleUser = await GoogleSignIn().signInSilently();

        googleUser ??= await GoogleSignIn().signIn();

        final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        debugPrint(FirebaseAuth.instance.currentUser!.displayName!);
      } catch (error) {
        debugPrint("Failed to sign in with Google: $error");
      }
    } else {
      debugPrint("User already signed in");
    }
  }

  static Future<List<Post>> getPosts(int count) async {
    //TODO fetch n posts
    //TODO fetch only new posts
    List<Post> posts = [];

    await db.collection("posts").get().then((event) {
      debugPrint("Posts: ${event.docs.length}:");
      for (var item in event.docs) {
        debugPrint("Post: ${item.id} => ${item.data()}");

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
      'isActive': true,
    });
  }

  static Future<String?> uploadImageToFirestore(XFile image, String folder) async {
    File file = File(image.path);
    String firebaseUserId = FirebaseAuth.instance.currentUser!.uid;
    String fileName = '${firebaseUserId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    String filePath = '$folder/$fileName';
    Reference ref = storageRef.child(filePath);

    try {
      await ref.putFile(file);
      String downloadURL = await ref.getDownloadURL();
      debugPrint('Firebase URL: $downloadURL');
      return downloadURL;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<Post> getSinglePost(String postId) async {
    late Post post;

    await db.collection("posts").doc(postId).get().then((event) {
      debugPrint("Post: ${event.id}: ${event.data()}");

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
}
