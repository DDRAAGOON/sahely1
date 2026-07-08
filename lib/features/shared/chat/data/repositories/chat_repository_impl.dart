import 'package:dartz/dart_z.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_room.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Stream<List<ChatMessage>> getMessages(String roomId) {
    return remoteDataSource.getMessages(roomId);
  }

  @override
  Future<Either<Failure, void>> sendMessage({
    required String roomId,
    required String content,
    MessageType type = MessageType.text,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.sendMessage(roomId, content, type.name);
        return const Right(null);
      } catch (e) {
        return const Left(ServerFailure('Failed to send message'));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<ChatRoom>>> getChatRooms() async {
    // Mock room list
    return const Right([
      ChatRoom(
        id: 'support',
        title: 'Customer Support',
        participantIds: ['me', 'support_bot'],
      ),
    ]);
  }

  @override
  Future<Either<Failure, ChatRoom>> createChatRoom(List<String> participantIds, String title) async {
     return const Left(ServerFailure('Not implemented'));
  }
}
