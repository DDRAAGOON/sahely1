import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class SahelyAiChatScreen extends StatefulWidget {
  final String? initialMessage;
  const SahelyAiChatScreen({super.key, this.initialMessage});

  @override
  State<SahelyAiChatScreen> createState() => _SahelyAiChatScreenState();
}

class _SahelyAiChatScreenState extends State<SahelyAiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    // Bot greeting
    _messages.add({
      'text': 'Hi! I\'m Sahely AI. I can help with WiFi, amenities, or stay details. What do you need?',
      'isMe': false,
    });
    
    if (widget.initialMessage != null) {
      _messages.add({
        'text': widget.initialMessage,
        'isMe': true,
      });
      _simulateBotResponse();
    }
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    
    setState(() {
      _messages.add({
        'text': _controller.text.trim(),
        'isMe': true,
      });
    });
    
    _controller.clear();
    _simulateBotResponse();
  }

  void _simulateBotResponse() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'text': 'I\'m looking into that for you! One moment...',
            'isMe': false,
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, color: AppColors.gold, size: 18),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sahely AI', style: TextStyle(color: AppColors.navy, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'DM Sans')),
                Text('Online', style: TextStyle(color: AppColors.success, fontSize: 11, fontFamily: 'DM Sans')),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['isMe'] as bool;
                
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isMe ? AppColors.navy : AppColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isMe ? 16 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 16),
                      ),
                    ),
                    child: Text(
                      msg['text'],
                      style: TextStyle(
                        color: isMe ? Colors.white : AppColors.dark,
                        fontSize: 14,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Input
          Container(
            padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -2))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Ask Sahely AI...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 14, color: AppColors.navy.withValues(alpha: 0.5)),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(color: AppColors.navy, shape: BoxShape.circle),
                    child: const Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
