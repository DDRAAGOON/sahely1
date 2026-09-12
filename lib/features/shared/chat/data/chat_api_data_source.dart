import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';

/// Remote data source for the `chat` module - conversations with human
/// customer support, plus the in-stay SOS escalation.
///
/// Moderation routes (assign / reply / resolve / status / open / assigned) are
/// admin-only and are intentionally not exposed here.
class ChatApiDataSource {
  final ApiClient apiClient;

  ChatApiDataSource(this.apiClient);

  // -- Conversations ----------------------------------------------------------

  /// Opens a support conversation, optionally with a first message.
  Future<Map<String, dynamic>> createConversation({String? message}) async {
    final res = await apiClient.post(
      ApiEndpoints.chatConversations,
      data: {if (message != null && message.isNotEmpty) 'message': message},
    );
    return asMap(unwrapData(res.data));
  }

  Future<List<Map<String, dynamic>>> fetchConversations({
    int page = 1,
    int limit = ApiEndpoints.defaultPageSize,
  }) async {
    final res = await apiClient.get(
      ApiEndpoints.chatConversations,
      queryParameters: pageQuery(page: page, limit: limit),
    );
    return asListOfMaps(unwrapData(res.data));
  }

  Future<Map<String, dynamic>> fetchConversation(String id) async {
    final res = await apiClient.get(ApiEndpoints.chatConversation(id));
    return asMap(unwrapData(res.data));
  }

  Future<void> closeConversation(String id) =>
      apiClient.post(ApiEndpoints.chatClose(id));

  /// Full-text search across the user's conversations.
  Future<List<Map<String, dynamic>>> searchConversations(String query) async {
    final res = await apiClient.get(
      ApiEndpoints.chatSearch,
      queryParameters: {'q': query},
    );
    return asListOfMaps(unwrapData(res.data));
  }

  // -- Messages ---------------------------------------------------------------

  Future<List<Map<String, dynamic>>> fetchMessages(
    String conversationId, {
    int page = 1,
    int limit = 50,
  }) async {
    final res = await apiClient.get(
      ApiEndpoints.chatMessages(conversationId),
      queryParameters: pageQuery(page: page, limit: limit),
    );
    return asListOfMaps(unwrapData(res.data));
  }

  /// [attachmentUrl] is an object key produced by the S3 upload flow.
  Future<Map<String, dynamic>> sendMessage({
    required String conversationId,
    required String message,
    String? attachmentUrl,
    String? attachmentType,
    Map<String, dynamic>? attachmentMetadata,
  }) async {
    final res = await apiClient.post(
      ApiEndpoints.chatMessages(conversationId),
      data: {
        'conversationId': conversationId,
        'message': message,
        if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
        if (attachmentType != null) 'attachmentType': attachmentType,
        if (attachmentMetadata != null)
          'attachmentMetadata': attachmentMetadata,
      },
    );
    return asMap(unwrapData(res.data));
  }

  Future<List<Map<String, dynamic>>> searchMessages(
    String conversationId,
    String query,
  ) async {
    final res = await apiClient.get(
      ApiEndpoints.chatMessageSearch(conversationId),
      queryParameters: {'q': query},
    );
    return asListOfMaps(unwrapData(res.data));
  }

  Future<void> markAsRead(String conversationId) =>
      apiClient.put(ApiEndpoints.chatRead(conversationId));

  /// Soft-deletes one of the user's own messages.
  Future<void> deleteMessage(String messageId) =>
      apiClient.delete(ApiEndpoints.chatMessage(messageId));

  /// Badge count for the support inbox.
  Future<int> unreadCount() async {
    final res = await apiClient.get(ApiEndpoints.chatUnreadCount);
    final data = unwrapData(res.data);
    if (data is num) return data.toInt();
    final map = asMap(data);
    return asNum(map['count'] ?? map['unread'] ?? map['unreadCount'])
            ?.toInt() ??
        0;
  }

  // -- SOS ---------------------------------------------------------------------

  /// Raises an urgent support ticket for an active stay.
  ///
  /// Only accepted from 1 hour before check-in to 1 hour after check-out; the
  /// backend rejects it outside that window.
  Future<Map<String, dynamic>> raiseSos(String bookingId) async {
    final res = await apiClient.post(
      ApiEndpoints.chatSos,
      data: {'booking_id': bookingId},
    );
    return asMap(unwrapData(res.data));
  }
}
