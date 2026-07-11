import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class HistoryTransactionRow extends StatelessWidget {
  final String type;
  final String title;
  final String subtitle;
  final int amount; // In piastres (negative for debits)
  final bool isViolation;

  const HistoryTransactionRow({
    super.key,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.isViolation = false,
  });

  IconData _getIcon() {
    switch (type) {
      case 'payment':
        return Icons.credit_card;
      case 'credit':
        return Icons.add;
      case 'violation':
        return Icons.warning_amber;
      case 'refund':
        return Icons.check;
      default:
        return Icons.circle;
    }
  }

  Color _getIconBgColor() {
    switch (type) {
      case 'payment':
        return AppColors.red.withValues(alpha: 0.1);
      case 'credit':
        return AppColors.green.withValues(alpha: 0.1);
      case 'violation':
        return AppColors.warning.withValues(alpha: 0.1);
      case 'refund':
        return AppColors.green.withValues(alpha: 0.1);
      default:
        return AppColors.secondary.withValues(alpha: 0.1);
    }
  }

  Color _getIconColor() {
    switch (type) {
      case 'payment':
        return AppColors.red;
      case 'credit':
        return AppColors.green;
      case 'violation':
        return AppColors.warning;
      case 'refund':
        return AppColors.green;
      default:
        return AppColors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final egpAmount = amount / 100;
    final isNegative = amount < 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Icon Circle
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _getIconBgColor(),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIcon(),
              color: _getIconColor(),
              size: 18,
            ),
          ),

          const SizedBox(width: 12),

          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.dark,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                    ),
                    // Amount
                    Text(
                      '${isNegative ? '-' : '+'}${egpAmount.abs().toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isNegative ? AppColors.red : AppColors.green,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.secondary,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    if (isViolation) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBF3DE),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Violation',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
