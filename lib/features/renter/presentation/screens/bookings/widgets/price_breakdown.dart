import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class PriceBreakdown extends StatelessWidget {
  final int nights;
  final int totalGuests;
  final int pricePerNight; // in piastres
  final int cleaningFee; // in piastres
  final int vat; // in piastres
  final int total; // in piastres

  const PriceBreakdown({
    super.key,
    required this.nights,
    required this.totalGuests,
    required this.pricePerNight,
    required this.cleaningFee,
    required this.vat,
    required this.total,
  });

  String _formatPrice(int piastres) {
    final amount = piastres / 100;
    // Format with commas for thousands
    return 'EGP ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    final egpPricePerNight = _formatPrice(pricePerNight);
    final subtotal = nights * pricePerNight;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (nights > 0) ...[
            Text(
              '$nights night${nights > 1 ? 's' : ''} · $totalGuests guest${totalGuests > 1 ? 's' : ''}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.secondary,
                fontFamily: 'DM Sans',
              ),
            ),
            const SizedBox(height: 16),
            _buildRow('$egpPricePerNight × $nights', _formatPrice(subtotal)),
            const SizedBox(height: 12),
            _buildRow('Cleaning fee', _formatPrice(cleaningFee)),
            const SizedBox(height: 12),
            _buildRow('VAT 14%', _formatPrice(vat)),
            const SizedBox(height: 20),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    fontFamily: 'DM Sans',
                  ),
                ),
                Text(
                  _formatPrice(total),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ],
            ),
          ] else
            const Center(
              child: Text(
                'Select dates to see pricing',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.secondary,
                  fontFamily: 'DM Sans',
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.secondary,
            fontFamily: 'DM Sans',
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.navy,
            fontFamily: 'DM Sans',
          ),
        ),
      ],
    );
  }
}
