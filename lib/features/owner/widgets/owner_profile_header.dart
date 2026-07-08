import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';

class OwnerProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback? onEditProfile;

  const OwnerProfileHeader({
    super.key,
    required this.name,
    required this.email,
    this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            const AvatarCircle(
              size: 64,
              colors: [Color(0xFFD8B98A), Color(0xFF7D5A2C)],
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.cream, width: 2),
                ),
                child: const Icon(Icons.camera_alt, size: 12, color: AppColors.navy),
              ),
            ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTheme.dm(
                  size: 18,
                  weight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              Text(
                email,
                style: AppTheme.dm(size: 13, color: AppColors.muted),
              ),
              GestureDetector(
                onTap: onEditProfile,
                child: Text(
                  'Edit Profile',
                  style: AppTheme.dm(
                    size: 13,
                    weight: FontWeight.w600,
                    color: AppColors.gold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OwnerTypeTag extends StatelessWidget {
  final String label;
  final IconData icon;

  const OwnerTypeTag({
    super.key,
    required this.label,
    this.icon = Icons.home_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFD7EEDD),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.success),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTheme.dm(
              size: 12,
              weight: FontWeight.w700,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}
