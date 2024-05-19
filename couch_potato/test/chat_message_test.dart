import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../lib/classes/chat_message.dart';

void main() {
  group('ChatMessage', () {
    test('should create a ChatMessage with given values', () {
      final timestamp = Timestamp.now();
      final message = ChatMessage(
        chatId: 'chat123',
        senderId: 'user123',
        text: 'Hello, world!',
        timestamp: timestamp,
      );

      expect(message.chatId, 'chat123');
      expect(message.senderId, 'user123');
      expect(message.text, 'Hello, world!');
      expect(message.timestamp, timestamp);
    });

    test('fromMap creates ChatMessage from a map', () {
      final timestamp = Timestamp.now();
      final map = {
        'chatId': 'chat123',
        'senderId': 'user123',
        'text': 'Hello, world!',
        'timestamp': timestamp,
      };

      final message = ChatMessage.fromMap(map);

      expect(message.chatId, 'chat123');
      expect(message.senderId, 'user123');
      expect(message.text, 'Hello, world!');
      expect(message.timestamp, timestamp);
    });

    test('toString returns correct string', () {
      final timestamp = Timestamp.now();
      final message = ChatMessage(
        chatId: 'chat123',
        senderId: 'user123',
        text: 'Hello, world!',
        timestamp: timestamp,
      );

      expect(message.toString(), 'Message(chatId: chat123, senderId: user123, text: Hello, world!, timestamp: $timestamp)');
    });
  });
}
