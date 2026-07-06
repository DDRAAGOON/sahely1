import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class UpcomingCheckinCard extends StatelessWidget {
  final Map<String, dynamic> checkin;
  final VoidCallback onTap;

  const UpcomingCheckinCard({
    super.key,
    required this.checkin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                checkin['imageUrl'],
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 64,
                    height: 64,
                    color: AppColors.border,
                    child: const Icon(
                      Icons.image,
                      color: AppColors.secondary,
                      size: 24,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    checkin['name'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${checkin['client']} ط¢آ· ${checkin['date']} ط¢آ· ${checkin['profit']}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondary,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Soon',
                style: TextStyle(
                  fontSize: 11,
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
