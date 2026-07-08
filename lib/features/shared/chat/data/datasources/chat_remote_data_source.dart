import 'dart:async';
import '../../../../../core/network/api_client.dart';
import '../models/chat_message_model.dart';

abstract class ChatRemoteDataSource {
  Stream<List<ChatMessageModel>> getMessages(String roomId);
  Future<void> sendMessage(String roomId, String content, String type);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiClient _apiClient;
  
  // Mock stream controller for demonstration
  final _messageStreamController = StreamController<List<ChatMessageModel>>.broadcast();

  ChatRemoteDataSourceImpl(this._apiClient);

  @override
  Stream<List<ChatMessageModel>> getMessages(String roomId) {
    // In a real app, this would be a WebSocket or Firebase connection
    // For now, we return a mock stream
    _simulateIncomingMessages();
    return _messageStreamController.stream;
  }

  @override
  Future<void> sendMessage(String roomId, String content, String type) async {
    // API Call to send message
    // await _apiClient.post('chat/send', data: {...});
  }

  void _simulateIncomingMessages() {
    Timer(const Duration(seconds: 1), () {
      _messageStreamController.add([
        ChatMessageModel(
          id: '1',
          senderId: 'support_bot',
          senderName: 'Sahely Support',
          content: 'Hello! How can we help you today?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
      ]);
    });
  }
}
