import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

import '../pages/edit_profile_screen.dart';

class BioCard extends StatelessWidget {
  final String bio;
  final String? instagramHandle;
  final String? tiktokHandle;
  final String? facebookHandle;

  const BioCard({
    super.key,
    required this.bio,
    this.instagramHandle,
    this.tiktokHandle,
    this.facebookHandle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bio Text
          Text(
            bio,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.dark,
              fontFamily: 'Cairo',
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          // Social Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (instagramHandle != null && instagramHandle!.isNotEmpty)
                _SocialChip(
                  icon: Icons.camera_alt,
                  label: instagramHandle!,
                  onTap: () {},
                ),
              if (tiktokHandle != null && tiktokHandle!.isNotEmpty)
                _SocialChip(
                  icon: Icons.music_note,
                  label: tiktokHandle!,
                  onTap: () {},
                ),
              if (facebookHandle != null && facebookHandle!.isNotEmpty)
                _SocialChip(
                  icon: Icons.facebook,
                  label: facebookHandle!,
                  onTap: () {},
                ),
              _SocialChip(
                icon: Icons.add,
                label: 'Add social',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.secondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.dark,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
