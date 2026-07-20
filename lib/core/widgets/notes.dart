import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class InfoNote extends StatelessWidget {
  const InfoNote(
      {super.key,
      required this.text,
      this.icon = Icons.info_outline,
      this.gold = true});

  final String text;
  final IconData icon;
  final bool gold;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF9F4),
        border: Border.all(color: const Color(0xFFE7D9A8)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.gold),
          const SizedBox(width: 8),
          Expanded(
              child: Text(text,
                  style: AppTheme.dm(
                      size: 12, color: const Color(0xFF8A6A1E), height: 1.45))),
        ],
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Text(text,
      style: AppTheme.dm(
          size: 12,
          weight: FontWeight.w700,
          color: AppColors.muted,
          letterSpacing: 1));
}
