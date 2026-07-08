import 'package:equatable/equatable.dart';

enum MessageType { text, image, file }

class ChatMessage extends Equatable {
  final String id;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final bool isMe;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    this.type = MessageType.text,
    this.isMe = false,
  });

  @override
  List<Object?> get props => [id, senderId, senderName, content, timestamp, type, isMe];
}
