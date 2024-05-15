class Chat {
  final String id;
  final String userId;
  final String userName;
  final String userPhoto;

  Chat({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhoto
  });

  @override
  String toString() {
    return 'Chat'; //(PostId: $postId, username: $username, createdAt: $createdAt, profileImageUrl: $profileImageUrl, description: $description, mediaUrl: $mediaUrl, mediaPlaceholder: $mediaPlaceholder, fullLocation: $fullLocation, category: $category)';
  }
}