import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

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
                    userName[0],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'DM Sans',
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
                        child: const Text(
                          'Sahely AI',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.gold,
                            fontFamily: 'DM Sans',
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
                  border: Border.all(
                    color: isAI
                        ? AppColors.gold.withValues(alpha: 0.3)
                        : AppColors.border,
                  ),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 13,
                    color: isAI ? AppColors.navy : AppColors.dark,
                    fontFamily: 'DM Sans',
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
