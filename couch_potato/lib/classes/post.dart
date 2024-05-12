class Post {
  final String postId;
  final String username;
  final String createdAt;
  final String profileImageUrl;
  final String description;
  final String mediaUrl;
  final String mediaPlaceholder;
  final String fullLocation;
  final String category;
  final String userId;

  Post({
    required this.postId,
    required this.username,
    required this.createdAt,
    required this.profileImageUrl,
    required this.description,
    required this.mediaUrl,
    required this.mediaPlaceholder,
    required this.fullLocation,
    required this.category,
    required this.userId,
  });

  @override
  String toString() {
    return 'Post(PostId: $postId, username: $username, createdAt: $createdAt, profileImageUrl: $profileImageUrl, description: $description, mediaUrl: $mediaUrl, mediaPlaceholder: $mediaPlaceholder, fullLocation: $fullLocation, category: $category, userId: $userId)';
  }
}
