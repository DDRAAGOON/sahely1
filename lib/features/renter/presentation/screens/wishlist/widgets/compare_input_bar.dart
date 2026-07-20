import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';

class CompareInputBar extends StatelessWidget {
  final Function(String) onSendMessage;
  final Function(String) onAskAI;

  const CompareInputBar({
    super.key,
    required this.onSendMessage,
    required this.onAskAI,
  });

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
                        decoration: const InputDecoration(
                          hintText: 'Message or ask AI to compare...',
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: AppColors.placeholder,
                            fontFamily: 'DM Sans',
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.dark,
                          fontFamily: 'DM Sans',
                        ),
                        onSubmitted: onSendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Send Button
            GestureDetector(
              onTap: () => onSendMessage(''),
              // Placeholder for current implementation
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send,
                  color: AppColors.navy,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
