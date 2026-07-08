import 'package:equatable/equatable.dart';
import 'chat_message.dart';

class ChatRoom extends Equatable {
  final String id;
  final String title;
  final String? imageUrl;
  final List<String> participantIds;
  final ChatMessage? lastMessage;
  final int unreadCount;

  const ChatRoom({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.participantIds,
    this.lastMessage,
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [id, title, imageUrl, participantIds, lastMessage, unreadCount];
}
