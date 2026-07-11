import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class ChatTimestamp extends StatelessWidget {
  final String text;

  const ChatTimestamp({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.border.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.secondary,
            fontFamily: 'DM Sans',
          ),
        ),
      ),
    );
  }
}
