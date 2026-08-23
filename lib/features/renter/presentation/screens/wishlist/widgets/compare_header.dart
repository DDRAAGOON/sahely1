import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

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
                  'Compare',
                  style: AppTheme.dm(
                    size: 18,
                    weight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  collectionName,
                  style: AppTheme.dm(
                    size: 12,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
          
          // Share Button
          GestureDetector(
            onTap: () => AppNavigation.goToShareCollection(
              context,
              collectionName: collectionName,
              shareableLink: 'sahely.app/compare/${collectionName.toLowerCase().replaceAll(' ', '-')}',
            ),
            child: Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link, size: 14, color: AppColors.navy),
                  const SizedBox(width: 4),
                  Text(
                    'Share',
                    style: AppTheme.dm(
                      size: 12,
                      weight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(width: 10),
          
          // Avatars
          SizedBox(
            width: 40,
            child: Stack(
              children: [
                for (int i = 0; i < participantNames.length && i < 2; i++)
                  Positioned(
                    left: i * 15.0,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _getAvatarColor(i),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.cream, width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          participantNames[i][0],
                          style: AppTheme.dm(
                            size: 10,
                            weight: FontWeight.w600,
                            color: Colors.white,
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
