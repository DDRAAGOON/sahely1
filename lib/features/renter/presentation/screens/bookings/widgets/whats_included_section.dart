import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class WhatsIncludedSection extends StatelessWidget {
  final List<dynamic>? included;
  final String title;

  const WhatsIncludedSection({
    super.key,
    this.included,
    this.title = "What's included",
  });

  @override
  Widget build(BuildContext context) {
    final includedList = included ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
            fontFamily: 'DM Sans',
          ),
        ),
        const SizedBox(height: 12),
        if (includedList.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: includedList.map((item) {
              final text = item.toString();
              final isPets = text.contains('Pets') || text.contains('Pets OK');
              
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isPets ? const Color(0xFFE8F5E9) : const Color(0xFFF3EFE7),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isPets ? const Color(0xFF2E7D32) : AppColors.navy.withOpacity(0.8),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isPets) ...[
                      const Icon(Icons.pets, size: 14, color: Color(0xFF2E7D32)),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isPets ? const Color(0xFF2E7D32) : AppColors.navy,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
