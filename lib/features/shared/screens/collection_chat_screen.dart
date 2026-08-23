import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/widgets/chat_message_bubble.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/widgets/compare_input_bar.dart';

import '../../../core/utils/currency_formatter.dart';

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
  final String collectionName;
  final List<String> participantNames;

  const CollectionChatScreen({
    super.key,
    this.collectionName = 'Beach Trip 2026',
    this.participantNames = const ['Omar', 'Nour', 'Sara'],
  });

  @override
  State<CollectionChatScreen> createState() => _CollectionChatScreenState();
}

class _CollectionChatScreenState extends State<CollectionChatScreen> {
  final List<_Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isAiTyping = false;

  @override
  void initState() {
    super.initState();
    _messages.addAll([
      _Message(
        userName: 'Omar',
        avatarColor: AppColors.gold,
        message: 'Azure has the better pool but Lagoon is closer to the water.',
      ),
      _Message(
        userName: 'Nour',
        avatarColor: AppColors.navy,
        message: 'Agreed — and Lagoon sleeps one more. Worth the extra?',
      ),
      _Message(
        userName: 'Sahely AI',
        avatarColor: AppColors.gold,
        message: 'Quick compare: Lagoon — +0.1★, sleeps 8, 3 min to beach. Azure — private pool, −${CurrencyFormatter.format(1700)}/night. For a beach-first group, Lagoon wins.',
        isAI: true,
      ),
    ]);
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

  void _triggerAI() {
    if (_isAiTyping) return;
    setState(() => _isAiTyping = true);
    _scrollToBottom();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isAiTyping = false);
        _addMessage(
          "Based on your conversation, Azure Beach Villa offers more privacy, while Lagoon Retreat is ideal for group activities near the shore.",
          isAI: true,
        );
      }
    });
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
                    child: const Icon(Icons.chevron_left, color: AppColors.navy),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.collectionName,
                            style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
                        Text('You, ${widget.participantNames.join(', ')}',
                            style: AppTheme.dm(size: 11, color: AppColors.muted)),
                      ],
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                  ),
                ],
              ),
            ),

            // VS Bar (Optional teaser)
            Container(
              padding: const EdgeInsets.all(10),
              color: AppColors.white,
              child: Row(
                children: [
                  Expanded(child: _vsCard('Azure', '4.8 · 4,500')),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('VS', style: AppTheme.dm(size: 12, weight: FontWeight.w700, color: AppColors.border)),
                  ),
                  Expanded(child: _vsCard('Lagoon', '4.9 · 6,200')),
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
              onSendMessage: (text) => _addMessage(text),
              onAskAI: (_) => _triggerAI(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vsCard(String name, String meta) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(border : null, borderRadius: BorderRadius.circular(10)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: AppColors.navy)),
          Text(meta, style: AppTheme.dm(size: 11, color: AppColors.muted)),
        ]),
      );

  Widget _buildTypingIndicator() {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
          child: const Icon(Icons.auto_awesome, size: 16, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
          child: Text('Sahely AI is thinking...', style: AppTheme.dm(size: 12, color: AppColors.gold, weight: FontWeight.w600)),
        ),
      ],
    );
  }
}
