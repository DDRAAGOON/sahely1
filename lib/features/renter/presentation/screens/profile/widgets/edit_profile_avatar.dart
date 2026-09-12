import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class EditProfileAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String? localPath;
  final VoidCallback onAvatarTap;

  const EditProfileAvatar({
    super.key,
    this.avatarUrl,
    this.localPath,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              // Avatar
              Container(
                width: 96,
                height: 96,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF7FA8BF), Color(0xFF2C5066)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: _buildImage(),
              ),
              // Camera badge
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onAvatarTap,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.cream,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: AppColors.navy,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onAvatarTap,
            child: Text(
              'Change photo',
              style: AppTheme.dm(
                size: 13,
                weight: FontWeight.w600,
                color: AppColors.gold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (localPath != null) {
      return ClipOval(
        child: Image.file(
          File(localPath!),
          fit: BoxFit.cover,
        ),
      );
    }

    if (avatarUrl != null) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: avatarUrl!,
          fit: BoxFit.cover,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold),
            ),
          ),
          errorWidget: (context, url, error) => const Icon(
            Icons.person,
            size: 52,
            color: Colors.white,
          ),
        ),
      );
    }

    return const Icon(
      Icons.person,
      size: 52,
      color: Colors.white,
    );
  }
}
