import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class CompareInputBar extends StatefulWidget {
  final Function(String) onSendMessage;
  final Function(String) onAskAI;

  const CompareInputBar({
    super.key,
    required this.onSendMessage,
    required this.onAskAI,
  });

  @override
  State<CompareInputBar> createState() => _CompareInputBarState();
}

class _CompareInputBarState extends State<CompareInputBar> {
  final TextEditingController _controller = TextEditingController();

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Text Field
            Expanded(
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Message or ask AI to compare...',
                          hintStyle: AppTheme.dm(
                            size: 13,
                            color: AppColors.placeholder,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: AppTheme.dm(
                          size: 13,
                          color: AppColors.dark,
                        ),
                        onSubmitted: (_) => _handleSend(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            // AI/Send Button
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (context, value, child) {
                final isTyping = value.text.trim().isNotEmpty;
                return GestureDetector(
                  onTap: isTyping ? _handleSend : () => widget.onAskAI('compare'),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.gold,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isTyping ? Icons.send : Icons.auto_awesome,
                      color: AppColors.navy,
                      size: 20,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
