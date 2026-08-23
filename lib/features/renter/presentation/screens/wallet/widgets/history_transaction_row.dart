import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/utils/currency_formatter.dart';

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
    final isNegative = amount < 0;
    final formattedAmount = CurrencyFormatter.formatNumber(amount.abs());

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
                        style: AppTheme.dm(
                          size: 14,
                          weight: FontWeight.w600,
                          color: AppColors.dark,
                        ),
                      ),
                    ),
                    // Amount
                    Text(
                      '${isNegative ? '-' : '+'}$formattedAmount',
                      style: AppTheme.dm(
                        size: 15,
                        weight: FontWeight.w700,
                        color: isNegative ? AppColors.red : AppColors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      subtitle,
                      style: AppTheme.dm(
                        size: 12,
                        color: AppColors.secondary,
                      ),
                    ),
                    if (isViolation) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBF3DE),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Violation',
                          style: AppTheme.dm(
                            size: 10,
                            weight: FontWeight.w700,
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
