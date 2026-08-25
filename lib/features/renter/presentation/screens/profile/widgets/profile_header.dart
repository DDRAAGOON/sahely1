import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/image.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? avatarUrl;
  final String? localAvatarPath;
  final bool isVerified;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.localAvatarPath,
    this.isVerified = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          // Avatar with Camera Badge
          Stack(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.navy.withValues(alpha: 0.2),
                ),
                child: _buildImage(),
              ),
              // Camera Badge (Gold)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.cream, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 12,
                    color: AppColors.navy,
                  ),
                ),
              ),
              // Verified Badge (if verified)
              if (isVerified)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.cream, width: 2),
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 14),

          // Name, Email, Edit Profile
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
                const SizedBox(height: 2),
                Text(
                  email,
                  style: AppTheme.dm(
                    size: 13,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () => AppNavigation.goToEditProfile(context),
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
      ),
    );
  }

  Widget _buildImage() {
    if (localAvatarPath != null) {
      return ClipOval(
          child: Image.file(File(localAvatarPath!), fit: BoxFit.cover));
    }
    if (avatarUrl != null) {
      return ClipOval(child: AppNetworkImage(url: avatarUrl!));
    }
    return const Icon(Icons.person, size: 32, color: AppColors.navy);
  }
}
