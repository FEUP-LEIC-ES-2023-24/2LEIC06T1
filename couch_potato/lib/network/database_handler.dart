import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couch_potato/classes/post.dart';
import 'package:couch_potato/classes/chat_message.dart';
import 'package:couch_potato/classes/chat.dart';
import 'package:couch_potato/screens/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static Future<List<Post>> getPosts() async {
    List<Post> posts = [];

    await db.collection("posts").where('isActive', isEqualTo: true).get().then((event) {
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
          userId: item.data()['userId'],
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
      'userId': FirebaseAuth.instance.currentUser!.uid,
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
        userId: event.data()!['userId'],
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

  static Future<void> fetchAndSaveFavorites() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      debugPrint('User not signed in');
      return;
    }

    CollectionReference favorites = db.collection('favorites');

    List<String> favoritePostIds = [];

    QuerySnapshot querySnapshot = await favorites.where('userId', isEqualTo: currentUser.uid).get();

    for (var doc in querySnapshot.docs) {
      favoritePostIds.add(doc['postId']);
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', favoritePostIds);

    debugPrint('Favorite Posts: ${prefs.getStringList('favorites')}');
  }

  static Future<void> addFavorite(String postId, bool remove) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    if (remove) {
      QuerySnapshot querySnapshot = await db
          .collection('favorites')
          .where('userId', isEqualTo: currentUser.uid)
          .where('postId', isEqualTo: postId)
          .get();
      for (var doc in querySnapshot.docs) {
        await db.collection('favorites').doc(doc.id).delete();
      }
    } else {
      await db.collection('favorites').add({
        'userId': currentUser.uid,
        'postId': postId,
      });
    }
  }

  static Future<List<Post>> fetchFavoritePosts() async {
    List<Post> favoritePosts = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoritePostIds = prefs.getStringList('favorites');

    if (favoritePostIds == null) return favoritePosts;

    for (String postId in favoritePostIds) {
      Post post = await getSinglePost(postId);
      favoritePosts.add(post);
    }

    return favoritePosts;
  }

  static Future<List<Post>> fetchUserPosts(bool open) async {
    List<Post> openPosts = [];

    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    await db
        .collection("posts")
        .where('userId', isEqualTo: currentUserId)
        .where('isActive', isEqualTo: open)
        .get()
        .then((event) {
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
          userId: item.data()['userId'],
        );

        openPosts.add(post);
      }
    });

    return openPosts;
  }

  static Future<void> closePost(String postId) async {
    await db.collection("posts").doc(postId).update({'isActive': false});

    QuerySnapshot querySnapshot = await db.collection('acquisitions').where('postId', isEqualTo: postId).get();
    for (var doc in querySnapshot.docs) {
      await db.collection('acquisitions').doc(doc.id).update({'status': 'acquired'});
    }
  }

  static Future<void> acquire(String postId, String donorId, String logistics, String donorName,
      String donorProfilePicUrl, BuildContext context) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String status = logistics == 'couch_potato' ? 'acquired' : 'pending';

    if (logistics == 'couch_potato') {
      await db.collection("posts").doc(postId).update({'isActive': false});
    } else {
      List<Chat> chats = await getChats(userId);

      Chat? existingChat;
      for (Chat chat in chats) {
        if (chat.userId == donorId) {
          existingChat = chat;
          break;
        }
      }

      if (existingChat == null) {
        Chat? newChat = await createChat(donorId, donorName, donorProfilePicUrl);
        if (context.mounted) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(chat: newChat!),
            ),
          );
        }
      } else if (context.mounted) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(chat: existingChat!),
          ),
        );
      }
    }

    await db.collection('acquisitions').add({
      'postId': postId,
      'donorId': donorId,
      'logistics': logistics,
      'receiverId': userId,
      'status': status,
    });
  }

  static Future<List<Post>> fetchCategorizedPosts(String category) async {
    List<Post> posts = [];

    await db
        .collection("posts")
        .where('isActive', isEqualTo: true)
        .where('category', isEqualTo: category)
        .get()
        .then((event) {
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
          userId: item.data()['userId'],
        );

        posts.add(post);
      }
    });

    return posts;
  }

  static Future<Chat?> createChat(String userId, String userName, String userPhoto) async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    late Chat result;

    await db.collection("chats").add({
      'user1Id': currentUserId,
      'user1Name': FirebaseAuth.instance.currentUser!.displayName,
      'user1Photo': FirebaseAuth.instance.currentUser!.photoURL,
      'user2Id': userId,
      'user2Name': userName,
      'user2Photo': userPhoto,
    }).then((value) {
      result = Chat(
        id: value.id,
        userId: userId,
        userName: userName,
        userPhoto: userPhoto,
      );
    }).onError((error, stackTrace) {
      throw Exception('Failed to create chat: $error');
    });

    return result;
  }
}
