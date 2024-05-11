import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatMessage {
  final String senderId;
  final String senderName;
  final String senderPhoto;
  final String receiverId;
  final String receiverName;
  final String receiverPhoto;
  final String text;
  final Timestamp timestamp; 

  ChatMessage({
    required this.senderId,
    required this.senderName,
    required this.senderPhoto,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPhoto,
    required this.text,
    required this.timestamp
  });

  @override
  String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'Message(senderId: $senderId, receiverId: $receiverId, text: $text, timestamp: $timestamp)';
  }

  
}