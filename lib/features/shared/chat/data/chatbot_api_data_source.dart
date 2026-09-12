import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';

/// Remote data source for the `chatbot` module - the AI assistant, which is a
/// separate conversation space from human support (`ChatApiDataSource`).
///
/// Admin moderation routes are intentionally not exposed here.
class ChatbotApiDataSource {
  final ApiClient apiClient;

  ChatbotApiDataSource(this.apiClient);

  /// [sessionId] lets an anonymous pre-login session be carried over.
  Future<Map<String, dynamic>> createConversation({
    String? initialMessage,
    String? sessionId,
  }) async {
    final res = await apiClient.post(
      ApiEndpoints.chatbotConversations,
      data: {
        if (initialMessage != null && initialMessage.isNotEmpty)
          'initialMessage': initialMessage,
        if (sessionId != null) 'sessionId': sessionId,
      },
    );
    return asMap(unwrapData(res.data));
  }

  Future<List<Map<String, dynamic>>> fetchConversations({
    int page = 1,
    int limit = ApiEndpoints.defaultPageSize,
  }) async {
    final res = await apiClient.get(
      ApiEndpoints.chatbotConversations,
      queryParameters: pageQuery(page: page, limit: limit),
    );
    return asListOfMaps(unwrapData(res.data));
  }

  Future<Map<String, dynamic>> fetchConversation(String id) async {
    final res = await apiClient.get(ApiEndpoints.chatbotConversation(id));
    return asMap(unwrapData(res.data));
  }

  Future<void> closeConversation(String id) =>
      apiClient.post(ApiEndpoints.chatbotClose(id));

  Future<List<Map<String, dynamic>>> fetchMessages(
    String conversationId, {
    int page = 1,
    int limit = 50,
  }) async {
    final res = await apiClient.get(
      ApiEndpoints.chatbotMessages(conversationId),
      queryParameters: pageQuery(page: page, limit: limit),
    );
    return asListOfMaps(unwrapData(res.data));
  }

  /// Sends a prompt; the reply comes back in the same response payload.
  Future<Map<String, dynamic>> sendMessage({
    required String conversationId,
    required String message,
    String? attachmentUrl,
    String? attachmentType,
    Map<String, dynamic>? attachmentMetadata,
  }) async {
    final res = await apiClient.post(
      ApiEndpoints.chatbotMessages(conversationId),
      data: {
        'message': message,
        'conversationId': conversationId,
        if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
        if (attachmentType != null) 'attachmentType': attachmentType,
        if (attachmentMetadata != null)
          'attachmentMetadata': attachmentMetadata,
      },
    );
    return asMap(unwrapData(res.data));
  }

  Future<void> markAsRead(String conversationId) =>
      apiClient.put(ApiEndpoints.chatbotRead(conversationId));

  Future<void> deleteMessage(String messageId) =>
      apiClient.delete(ApiEndpoints.chatbotMessage(messageId));

  Future<int> unreadCount() async {
    final res = await apiClient.get(ApiEndpoints.chatbotUnreadCount);
    final data = unwrapData(res.data);
    if (data is num) return data.toInt();
    final map = asMap(data);
    return asNum(map['count'] ?? map['unread'] ?? map['unreadCount'])
            ?.toInt() ??
        0;
  }
}
