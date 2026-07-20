import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';

import '../../../../../../core/theme/app_colors.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ask Sahely AI',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
            fontFamily: 'DM Sans',
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Questions about this stay — not live support.',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.secondary,
            fontFamily: 'DM Sans',
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AI Message
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: AppColors.navy,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Hi! I can help with WiFi, the pool heater, nearby restaurants or checkout steps. What do you need?',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.dark,
                          fontFamily: 'DM Sans',
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Quick Questions
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _QuickQuestionChip(
                      label: 'How does the pool heater work?',
                      onTap: () => _goToChat('How does the pool heater work?'),
                    ),
                    const SizedBox(width: 8),
                    _QuickQuestionChip(
                      label: 'Checkout time?',
                      onTap: () => _goToChat('Checkout time?'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Input Field
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Ask about your stay...',
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: AppColors.navy.withValues(alpha: 0.5),
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
                        onSubmitted: (_) => _goToChat(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _goToChat(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.navy,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickQuestionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickQuestionChip({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.gold, width: 1),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.navy,
            fontFamily: 'DM Sans',
          ),
        ),
      ),
    );
  }
}
