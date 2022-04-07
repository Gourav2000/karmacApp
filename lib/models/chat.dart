import 'package:flutter/material.dart';

class Chat {
  final String name;
  final String id;
  final String number;
  final String latestMessage;
  final String latestMessageTime;
  final String latestMessageType;

  Chat({
    required this.id,
    required this.name,
    required this.number,
    required this.latestMessage,
    required this.latestMessageTime,
    required this.latestMessageType,
  });
}
