import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couch_potato/classes/post.dart';

class DatabaseHandler {
  static final db = FirebaseFirestore.instance;

  static Future<List<Post>> getPosts(int count) async {
    List<Post> posts = [];

    await db.collection("posts").get().then((event) {
      for (var item in event.docs) {
        print("${item.id} => ${item.data()}");

        Post post = Post(
          postId: item.id,
          username: item.data()['username'],
          createdAt: item.data()['createdAt'],
          profileImageUrl: item.data()['profileImageUrl'],
          description: item.data()['description'],
          mediaUrl: item.data()['mediaUrl'],
          mediaPlaceholder: item.data()['mediaPlaceholder'],
          fullLocation: item.data()['fullLocation'],
        );

        posts.add(post);
      }
    });

    return posts;
  }

}