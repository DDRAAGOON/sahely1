import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

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
          const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFF991B1B), size: 20),
              SizedBox(width: 8),
              Text(
                'Report an issue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF991B1B),
                  fontFamily: 'DM Sans',
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
              style: const TextStyle(fontSize: 13, color: Color(0xFF4B5563), fontFamily: 'DM Sans', height: 1.5),
              decoration: const InputDecoration(
                hintText: 'e.g. Microwave doesn\'t turn on...',
                hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(12),
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
                      ? Image.network(photoPath, width: 80, height: 80, fit: BoxFit.cover)
                      : Image.file(File(photoPath), width: 80, height: 80, fit: BoxFit.cover),
                  ),
                )),
                // Add Photo Button
                GestureDetector(
                  onTap: onAddPhoto,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.gold, width: 1, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: AppColors.gold, size: 24),
                        SizedBox(height: 4),
                        Text('Photo', style: TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w600)),
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
