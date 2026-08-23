import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class ReportIssueSection extends StatelessWidget {
  final TextEditingController controller;
  final List<String> photos;
  final VoidCallback onAddPhoto;

  const ReportIssueSection({
    super.key,
    required this.controller,
    required this.photos,
    required this.onAddPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFEE2E2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Color(0xFF991B1B), size: 20),
              const SizedBox(width: 8),
              Text(
                'Report an issue',
                style: AppTheme.dm(
                  size: 16,
                  weight: FontWeight.w700,
                  color: const Color(0xFF991B1B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Inline Edit Field
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              maxLines: 3,
              style: AppTheme.dm(
                  size: 13,
                  color: const Color(0xFF4B5563),
                  height: 1.5),
              decoration: InputDecoration(
                hintText: 'e.g. Microwave doesn\'t turn on...',
                hintStyle: AppTheme.dm(color: const Color(0xFF9CA3AF), size: 13),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ),

          const SizedBox(height: 16),
          // Photo Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...photos.map((photoPath) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: photoPath.startsWith('http')
                            ? Image.network(photoPath,
                                width: 80, height: 80, fit: BoxFit.cover)
                            : Image.file(File(photoPath),
                                width: 80, height: 80, fit: BoxFit.cover),
                      ),
                    )),
                // Add Photo Button
                GestureDetector(
                  onTap: onAddPhoto,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.borderDefault, width: 1),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add, color: AppColors.gold, size: 24),
                        const SizedBox(height: 4),
                        Text('Photo',
                            style: AppTheme.dm(
                                color: AppColors.gold,
                                size: 11,
                                weight: FontWeight.w600)),
                      ],
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
}
