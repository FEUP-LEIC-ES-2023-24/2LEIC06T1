import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatMessage {
  final String chatId;
  final String senderId;
  final String text;
  final Timestamp timestamp; 

  ChatMessage({
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.timestamp
  });

  @override
  String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'Message(chatId: $chatId, senderId: $senderId, text: $text, timestamp: $timestamp)';
  }

  
}