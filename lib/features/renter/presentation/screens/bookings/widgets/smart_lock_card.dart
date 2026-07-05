import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class SmartLockCard extends StatelessWidget {
  final VoidCallback onTap;

  const SmartLockCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.lock_outline,
              color: AppColors.gold,
              size: 18,
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Smart lock ready — tap to access your property',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'DM Sans',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
