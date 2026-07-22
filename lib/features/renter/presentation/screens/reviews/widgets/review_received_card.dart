import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';

class ReviewReceivedCard extends StatelessWidget {
  final String hostName;
  final String hostRole;
  final String? hostAvatar;
  final int rating;
  final String reviewText;

  const ReviewReceivedCard({
    super.key,
    required this.hostName,
    required this.hostRole,
    this.hostAvatar,
    required this.rating,
    required this.reviewText,
  });

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'owner':
        return AppColors.mawsemTeal;
      case 'broker':
        return AppColors.gold;
      default:
        return AppColors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleColor = _getRoleColor(hostRole);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF9F4), // Gold tint from image
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: AppColors.gold.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Host Info Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Host Avatar
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFA08050), Color(0xFFC9A84C)],
                  ),
                ),
                child: hostAvatar != null
                    ? ClipOval(
                        child: Image.network(
                          hostAvatar!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.person,
                                  color: Colors.white, size: 24),
                        ),
                      )
                    : const Icon(Icons.person, color: Colors.white, size: 24),
              ),

              const SizedBox(width: 12),

              // Host Name + Role Badge + Stars
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          hostName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Role Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBF3DE),
                            // Light gold from image
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            hostRole,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: roleColor,
                              fontFamily: 'DM Sans',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    // Stars
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          size: 16,
                          color: AppColors.gold,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Review Text
          Text(
            reviewText,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF424446), // Muted dark grey from image
              fontFamily: 'DM Sans',
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
