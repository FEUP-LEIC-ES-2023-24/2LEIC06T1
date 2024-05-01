import 'package:flutter_test/flutter_test.dart';
import 'package:couch_potato/classes/post.dart';

void main() {
  group('Post', () {
    late Post post;

    setUp(() {
      // Initialize a new Post object before each test
      post = Post(
        postId: '123',
        username: 'test_user',
        createdAt: '2024-04-30',
        profileImageUrl: 'https://example.com/profile.png',
        description: 'Test description',
        mediaUrl: 'https://example.com/media.png',
        mediaPlaceholder: 'media_placeholder',
        fullLocation: 'Test location',
        category: 'Test category',
      );
    });

    test('Post toString method', () {
      // Test the toString method of the Post class
      expect(
        post.toString(),
        'Post(PostId: 123, username: test_user, createdAt: 2024-04-30, profileImageUrl: https://example.com/profile.png, description: Test description, mediaUrl: https://example.com/media.png, mediaPlaceholder: media_placeholder, fullLocation: Test location, category: Test category)',
      );
    });

  });
}
