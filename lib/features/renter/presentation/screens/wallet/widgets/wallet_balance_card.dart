import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/utils/currency_formatter.dart';

class WalletBalanceCard extends StatelessWidget {
  final int balance; // In piastres
  final String subtitle;

  const WalletBalanceCard({
    super.key,
    required this.balance,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final egpBalance = balance / 100;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      // To ensure the circle is clipped by the card corners
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.navy,
            Color(0xFF243358),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          // Background Decorative Circle - Exact Mawsem Hero Card Style
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.gold.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sahely Credit Balance',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: 'DM Sans',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${CurrencyFormatter.defaultSymbol} ${CurrencyFormatter.formatNumber(egpBalance)}',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gold,
                    fontFamily: 'DM Sans',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
