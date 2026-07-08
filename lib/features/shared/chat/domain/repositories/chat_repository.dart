import 'package:dartz/dart_z.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/chat_message.dart';
import '../entities/chat_room.dart';

abstract class ChatRepository {
  Stream<List<ChatMessage>> getMessages(String roomId);
  
  Future<Either<Failure, void>> sendMessage({
    required String roomId,
    required String content,
    MessageType type = MessageType.text,
  });

  Future<Either<Failure, List<ChatRoom>>> getChatRooms();

  Future<Either<Failure, ChatRoom>> createChatRoom(List<String> participantIds, String title);
}
