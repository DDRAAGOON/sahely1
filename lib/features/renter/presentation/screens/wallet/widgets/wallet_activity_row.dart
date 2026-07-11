import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class WalletActivityRow extends StatelessWidget {
  final String type;
  final String title;
  final String subtitle;
  final int amount; // In piastres (negative for debits)

  const WalletActivityRow({
    super.key,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.amount,
  });

  IconData _getIcon() {
    switch (type) {
      case 'booking':
        return Icons.credit_card;
      case 'credit_added':
        return Icons.add_circle;
      case 'violation':
        return Icons.warning_amber;
      default:
        return Icons.circle;
    }
  }

  Color _getIconColor() {
    switch (type) {
      case 'booking':
        return AppColors.red;
      case 'credit_added':
        return AppColors.green;
      case 'violation':
        return AppColors.warning;
      default:
        return AppColors.secondary;
    }
  }

  Color _getIconBgColor() {
    switch (type) {
      case 'booking':
        return AppColors.red.withValues(alpha: 0.1);
      case 'credit_added':
        return AppColors.green.withValues(alpha: 0.1);
      case 'violation':
        return AppColors.warning.withValues(alpha: 0.1);
      default:
        return AppColors.secondary.withValues(alpha: 0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final egpAmount = amount / 100;
    final isNegative = amount < 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getIconBgColor(),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIcon(),
              color: _getIconColor(),
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.dark,
                    fontFamily: 'DM Sans',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondary,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Amount
          Text(
            '${isNegative ? '-' : '+'}${egpAmount.abs().toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isNegative ? AppColors.red : AppColors.green,
              fontFamily: 'DM Sans',
            ),
          ),
        ],
      ),
    );
  }
}
