import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';

class OwnerBioCard extends StatelessWidget {
  final String bio;
  final String handle;
  final IconData handleIcon;

  const OwnerBioCard({
    super.key,
    required this.bio,
    required this.handle,
    this.handleIcon = Icons.camera_alt_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bio,
            style: AppTheme.dm(size: 13, height: 1.4),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(handleIcon, size: 14, color: AppColors.gold),
                const SizedBox(width: 6),
                Text(handle, style: AppTheme.dm(size: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
