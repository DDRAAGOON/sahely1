import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';

class CompareHeader extends StatelessWidget {
  final String collectionName;
  final List<String> participantNames;
  final VoidCallback onBackTap;

  const CompareHeader({
    super.key,
    required this.collectionName,
    required this.participantNames,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: const BoxDecoration(
        color: AppColors.cream,
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: onBackTap,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.chevron_left,
                color: AppColors.navy,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Title & Participants
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  collectionName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    fontFamily: 'DM Sans',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'You, ${participantNames.take(2).join(', ')}${participantNames.length > 2 ? ', ${participantNames[2]}' : ''}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondary,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ],
            ),
          ),
          // Avatars
          SizedBox(
            width: 60,
            child: Stack(
              children: [
                for (int i = 0; i < participantNames.length && i < 3; i++)
                  Positioned(
                    left: i * 20.0,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: _getAvatarColor(i),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.cream, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          participantNames[i][0],
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getAvatarColor(int index) {
    final colors = [
      AppColors.navy,
      AppColors.mawsemTeal,
      AppColors.gold,
      AppColors.red,
    ];
    return colors[index % colors.length];
  }
}
