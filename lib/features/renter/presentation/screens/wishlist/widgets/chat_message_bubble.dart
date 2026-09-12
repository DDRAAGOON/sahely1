import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class ChatMessageBubble extends StatelessWidget {
  final String userName;
  final Color avatarColor;
  final String message;
  final bool isAI;

  const ChatMessageBubble({
    super.key,
    required this.userName,
    required this.avatarColor,
    required this.message,
    required this.isAI,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: avatarColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isAI
                ? const Icon(
                    Icons.auto_awesome,
                    size: 16,
                    color: Colors.white,
                  )
                : Text(
                    userName.isNotEmpty ? userName[0] : '?',
                    style: AppTheme.dm(
                      size: 12,
                      weight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 10),
        // Message Bubble
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name (for AI)
              if (isAI)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Sahely AI',
                          style: AppTheme.dm(
                            size: 10,
                            weight: FontWeight.w600,
                            color: AppColors.gold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              // Bubble
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isAI
                      ? AppColors.gold.withValues(alpha: 0.15)
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      isAI ? null : Border.all(color: AppColors.borderDefault),
                ),
                child: Text(
                  message,
                  style: AppTheme.dm(
                    size: 13,
                    color: isAI ? AppColors.navy : AppColors.dark,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
