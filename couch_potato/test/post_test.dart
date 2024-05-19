import 'package:flutter_test/flutter_test.dart';
import '../lib/classes/post.dart';

void main() {
  group('Post', () {
    test('should create a Post with given values', () {
      final post = Post(
        postId: 'post123',
        username: 'user123',
        createdAt: '2021-01-01',
        profileImageUrl: 'http://example.com/profile.jpg',
        description: 'This is a post description.',
        mediaUrl: 'http://example.com/media.jpg',
        mediaPlaceholder: 'media_placeholder',
        fullLocation: 'Location Name',
        category: 'Category Name',
        userId: 'user123',
      );

      expect(post.postId, 'post123');
      expect(post.username, 'user123');
      expect(post.createdAt, '2021-01-01');
      expect(post.profileImageUrl, 'http://example.com/profile.jpg');
      expect(post.description, 'This is a post description.');
      expect(post.mediaUrl, 'http://example.com/media.jpg');
      expect(post.mediaPlaceholder, 'media_placeholder');
      expect(post.fullLocation, 'Location Name');
      expect(post.category, 'Category Name');
      expect(post.userId, 'user123');
    });

    test('toString returns correct string', () {
      final post = Post(
        postId: 'post123',
        username: 'user123',
        createdAt: '2021-01-01',
        profileImageUrl: 'http://example.com/profile.jpg',
        description: 'This is a post description.',
        mediaUrl: 'http://example.com/media.jpg',
        mediaPlaceholder: 'media_placeholder',
        fullLocation: 'Location Name',
        category: 'Category Name',
        userId: 'user123',
      );

      expect(post.toString(), 'Post(PostId: post123, username: user123, createdAt: 2021-01-01, profileImageUrl: http://example.com/profile.jpg, description: This is a post description., mediaUrl: http://example.com/media.jpg, mediaPlaceholder: media_placeholder, fullLocation: Location Name, category: Category Name, userId: user123)');
    });
  });
}
