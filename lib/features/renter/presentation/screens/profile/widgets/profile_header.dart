import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';

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
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.secondary,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () => AppNavigation.goToEditProfile(context),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gold,
                      fontFamily: 'Cairo',
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
      return ClipOval(child: Image.network(avatarUrl!, fit: BoxFit.cover));
    }
    return const Icon(Icons.person, size: 32, color: AppColors.navy);
  }
}
