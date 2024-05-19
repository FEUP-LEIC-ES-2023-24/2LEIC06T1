import 'package:flutter_test/flutter_test.dart';
import '../lib/classes/chat.dart';

void main() {
  group('Chat', () {
    test('should create a Chat with given values', () {
      final chat = Chat(
        id: 'chat123',
        userId: 'user123',
        userName: 'Test User',
        userPhoto: 'http://example.com/photo.jpg',
      );

      expect(chat.id, 'chat123');
      expect(chat.userId, 'user123');
      expect(chat.userName, 'Test User');
      expect(chat.userPhoto, 'http://example.com/photo.jpg');
    });

    test('toString returns correct string', () {
      final chat = Chat(
        id: 'chat123',
        userId: 'user123',
        userName: 'Test User',
        userPhoto: 'http://example.com/photo.jpg',
      );

      expect(chat.toString(), 'Chat');
    });
  });
}
