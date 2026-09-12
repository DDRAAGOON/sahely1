import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/widgets/chat_message_bubble.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/widgets/compare_input_bar.dart';

import '../../../core/utils/currency_formatter.dart';
import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/features/renter/data/datasources/wishlist_api_data_source.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/features/shared/chat/data/chatbot_session.dart';

class _Message {
  final String userName;
  final Color avatarColor;
  final String message;
  final bool isAI;

  _Message({
    required this.userName,
    required this.avatarColor,
    required this.message,
    this.isAI = false,
  });
}

class CollectionChatScreen extends StatefulWidget {
  final String collectionId;
  final String collectionName;
  final List<String> participantNames;

  /// The first two saved listings, compared in the bar at the top.
  final Property? propertyA;
  final Property? propertyB;

  const CollectionChatScreen({
    super.key,
    this.collectionId = '',
    this.collectionName = '',
    this.participantNames = const [],
    this.propertyA,
    this.propertyB,
  });

  @override
  State<CollectionChatScreen> createState() => _CollectionChatScreenState();
}

class _CollectionChatScreenState extends State<CollectionChatScreen> {
  final List<_Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isAiTyping = false;

  late final ChatbotSession _assistant = ChatbotSession();

  /// Group messages from `/wishlists/:id/messages` (newest first there).
  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  bool get _hasChat => widget.collectionId.isNotEmpty;

  Future<void> _loadMessages() async {
    if (!_hasChat) return;
    final api = sl<WishlistApiDataSource>();
    try {
      final rows = await api.fetchMessages(widget.collectionId);
      if (!mounted) return;
      setState(() {
        _messages
          ..clear()
          ..addAll(rows.reversed.map(_fromApi));
      });
      _scrollToBottom();
      await api.markChatRead(widget.collectionId);
    } catch (_) {
      // The conversation simply starts empty.
    }
  }

  static _Message _fromApi(Map<String, dynamic> row) {
    final mine = row['is_mine'] == true;
    final sender = asMap(row['sender']);
    final name = [sender['first_name'], sender['last_name']]
        .where((part) => part != null && '$part'.trim().isNotEmpty)
        .join(' ');
    return _Message(
      userName: mine ? 'You' : (name.isEmpty ? 'Member' : name),
      avatarColor: mine ? Colors.blueGrey : AppColors.navy,
      message: '${row['body'] ?? ''}',
    );
  }

  void _addMessage(String text, {bool isAI = false}) {
    setState(() {
      _messages.add(_Message(
        userName: isAI ? 'Sahely AI' : 'You',
        avatarColor: isAI ? AppColors.gold : Colors.blueGrey,
        message: text,
        isAI: isAI,
      ));
    });
    _scrollToBottom();
  }

  Future<void> _send(String text) async {
    if (text.trim().isEmpty) return;
    _addMessage(text);
    if (!_hasChat) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await sl<WishlistApiDataSource>().sendMessage(widget.collectionId, text);
    } catch (_) {
      messenger.showSnackBar(const SnackBar(
          content: Text('Could not send your message. Please try again.')));
    }
  }

  /// Asks the Sahely assistant, with the compared listings as context.
  Future<void> _askAssistant(String typed) async {
    if (_isAiTyping) return;
    final a = widget.propertyA;
    final b = widget.propertyB;
    final question = typed.trim().isNotEmpty
        ? typed.trim()
        : (a != null && b != null)
            ? 'Compare ${a.name} and ${b.name} for our group.'
            : 'Help us choose between the places in "${widget.collectionName}".';
    setState(() => _isAiTyping = true);
    _scrollToBottom();
    String reply;
    try {
      reply = await _assistant.ask(question) ?? ChatbotSession.pendingNotice;
    } catch (_) {
      reply = 'The assistant is unavailable right now. Please try again.';
    }
    if (!mounted) return;
    setState(() => _isAiTyping = false);
    _addMessage(reply, isAI: true);
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child:
                        const Icon(Icons.chevron_left, color: AppColors.navy),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.collectionName,
                            style: AppTheme.dm(
                                size: 15,
                                weight: FontWeight.w700,
                                color: AppColors.navy)),
                        Text(
                            widget.participantNames.isEmpty
                                ? 'You'
                                : 'You, ${widget.participantNames.join(', ')}',
                            style:
                                AppTheme.dm(size: 11, color: AppColors.muted)),
                      ],
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                        color: AppColors.gold, shape: BoxShape.circle),
                  ),
                ],
              ),
            ),

            // VS bar: the first two saved listings.
            if (widget.propertyA != null && widget.propertyB != null)
              Container(
                padding: const EdgeInsets.all(10),
                color: AppColors.white,
                child: Row(
                  children: [
                    Expanded(child: _vsCard(widget.propertyA!)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('VS',
                          style: AppTheme.dm(
                              size: 12,
                              weight: FontWeight.w700,
                              color: AppColors.border)),
                    ),
                    Expanded(child: _vsCard(widget.propertyB!)),
                  ],
                ),
              ),

            // Chat List
            Expanded(
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length + (_isAiTyping ? 1 : 0),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isAiTyping) {
                    return _buildTypingIndicator();
                  }
                  final msg = _messages[index];
                  return ChatMessageBubble(
                    userName: msg.userName,
                    avatarColor: msg.avatarColor,
                    message: msg.message,
                    isAI: msg.isAI,
                  );
                },
              ),
            ),

            // Input Bar
            CompareInputBar(
              onSendMessage: _send,
              onAskAI: _askAssistant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _vsCard(Property p) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: null, borderRadius: BorderRadius.circular(10)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.dm(
                  size: 13, weight: FontWeight.w700, color: AppColors.navy)),
          Text(
              '${p.reviews == 0 ? '—' : p.rating.toStringAsFixed(1)} · ${CurrencyFormatter.formatNumber(p.price)}',
              style: AppTheme.dm(size: 11, color: AppColors.muted)),
        ]),
      );

  Widget _buildTypingIndicator() {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
              color: AppColors.gold, shape: BoxShape.circle),
          child: const Icon(Icons.auto_awesome, size: 16, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12)),
          child: Text('Sahely AI is thinking...',
              style: AppTheme.dm(
                  size: 12, color: AppColors.gold, weight: FontWeight.w600)),
        ),
      ],
    );
  }
}
