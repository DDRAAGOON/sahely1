import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class ChecklistItem extends StatelessWidget {
  final String label;
  final bool isCompleted;
  final bool issueReported;
  final VoidCallback onTap;
  final VoidCallback onReportIssue;

  const ChecklistItem({
    super.key,
    required this.label,
    required this.isCompleted,
    required this.issueReported,
    required this.onTap,
    required this.onReportIssue,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Status Icon
            _buildStatusIcon(),
            const SizedBox(width: 12),
            // Label
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTheme.dm(
                      size: 14,
                      color: isCompleted
                          ? AppColors.secondary
                          : const Color(0xFF1B2744),
                      weight:
                          isCompleted ? FontWeight.w400 : FontWeight.w600,
                    ),
                  ),
                  if (issueReported)
                    Text(
                      'Issue reported',
                      style: AppTheme.dm(
                        size: 11,
                        color: const Color(0xFFD2760A),
                        weight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            // Action Button (Camera)
            if (issueReported)
              GestureDetector(
                onTap: onReportIssue,
                child: Container(
                  width: 36,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B2744),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              )
            else if (!isCompleted)
              GestureDetector(
                onTap: onReportIssue,
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: Color(0xFFE0D8CC),
                  size: 22,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    if (isCompleted) {
      return Container(
        width: 26,
        height: 26,
        decoration: const BoxDecoration(
          color: Color(0xFF1B6B3A),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 16),
      );
    }
    if (issueReported) {
      return Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD2760A), width: 1.5),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '!',
            style: AppTheme.dm(
              color: const Color(0xFFD2760A),
              weight: FontWeight.w900,
              size: 14,
            ),
          ),
        ),
      );
    }
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderDefault),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
