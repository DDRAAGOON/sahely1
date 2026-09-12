import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/features/shared/chat/data/chatbot_api_data_source.dart';

/// One conversation with the Sahely assistant (`/chatbot`).
///
/// The conversation is created with the first question. Sending a message
/// returns only the message itself - the assistant (or a Sahely agent the
/// conversation escalates to) answers separately - so [ask] polls the
/// conversation briefly for that answer.
class ChatbotSession {
  ChatbotSession({ChatbotApiDataSource? api})
      : _api = api ?? sl<ChatbotApiDataSource>();

  final ChatbotApiDataSource _api;
  String? _conversationId;

  /// Shown when no answer arrived in time; the reply still lands in the
  /// conversation.
  static const pendingNotice =
      'Your question was sent. The Sahely team will answer here shortly.';

  /// Sends [question] and returns the answer, or null when none arrived
  /// within [wait].
  Future<String?> ask(
    String question, {
    Duration wait = const Duration(seconds: 12),
  }) async {
    final id = _conversationId ??= await _createConversation();
    final sent = await _api.sendMessage(conversationId: id, message: question);
    final sentAt = DateTime.tryParse('${sent['createdAt'] ?? ''}');

    final deadline = DateTime.now().add(wait);
    while (DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(const Duration(seconds: 2));
      final messages = await _api.fetchMessages(id);
      for (final message in messages) {
        final fromUser =
            '${message['senderRole'] ?? ''}'.toUpperCase() == 'USER';
        final at = DateTime.tryParse('${message['createdAt'] ?? ''}');
        final isNew = sentAt == null || (at != null && at.isAfter(sentAt));
        final text = '${message['message'] ?? ''}'.trim();
        if (!fromUser && isNew && text.isNotEmpty) return text;
      }
    }
    return null;
  }

  Future<String> _createConversation() async {
    final conversation = await _api.createConversation();
    final id = '${conversation['id'] ?? ''}';
    if (id.isEmpty) throw StateError('The assistant is unavailable.');
    return id;
  }
}
