import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class SupportMessageBubble extends StatelessWidget {
  final String agentName;
  final String message;
  final bool showAvatar;

  const SupportMessageBubble({
    super.key,
    required this.agentName,
    required this.message,
    required this.showAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        if (showAvatar)
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFC62828),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning,
              color: Colors.white,
              size: 16,
            ),
          )
        else
          const SizedBox(width: 32),
        const SizedBox(width: 10),
        // Message
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Agent Name
              if (showAvatar)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    agentName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                ),
              // Bubble
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.dark,
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
