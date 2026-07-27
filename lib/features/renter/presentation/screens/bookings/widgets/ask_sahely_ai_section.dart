import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';

import 'package:sahely/core/theme/app_colors.dart';

class AskSahelyAiSection extends StatefulWidget {
  const AskSahelyAiSection({super.key});

  @override
  State<AskSahelyAiSection> createState() => _AskSahelyAiSectionState();
}

class _AskSahelyAiSectionState extends State<AskSahelyAiSection> {
  final TextEditingController _controller = TextEditingController();

  void _goToChat([String? message]) {
    final msg =
        message ?? (_controller.text.isNotEmpty ? _controller.text : null);
    AppNavigation.goToAiChat(context, extra: msg);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _goToChat(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: AppColors.navy,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ask Sahely AI',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Questions about this stay â€” directions, parking, check-in',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.7),
                      fontFamily: 'DM Sans',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Chat Icon
            const Icon(
              Icons.chat_bubble_outline,
              color: AppColors.gold,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
