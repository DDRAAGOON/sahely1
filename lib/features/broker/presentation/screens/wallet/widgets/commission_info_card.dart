import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class CommissionInfoCard extends StatelessWidget {
  final String pendingBalance;

  const CommissionInfoCard({
    super.key,
    required this.pendingBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF7EC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAD9A8)),
      ),
      child: Row(
        children: [
          // Clock Icon
          const Icon(
            Icons.access_time,
            color: Color(0xFFD2760A),
            size: 20,
          ),
          const SizedBox(width: 12),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Commissions clear 48h after guest check-in.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8A6A1E),
                    fontFamily: 'DM Sans',
                  ),
                ),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'DM Sans',
                    ),
                    children: [
                      const TextSpan(
                        text: 'Pending balance: ',
                        style: TextStyle(color: Color(0xFF8A6A1E)),
                      ),
                      TextSpan(
                        text: 'EGP $pendingBalance',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFD2760A),
                        ),
                      ),
                    ],
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