import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class BlockedActionGate extends StatelessWidget {
  final bool emailVerified;
  final bool phoneVerified;
  final bool idVerified;
  final bool cardAdded;
  final VoidCallback onCompleteSetup;
  final VoidCallback onNotNow;

  const BlockedActionGate({
    super.key,
    required this.emailVerified,
    required this.phoneVerified,
    required this.idVerified,
    required this.cardAdded,
    required this.onCompleteSetup,
    required this.onNotNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cream, // Matching the image background
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE0D8CC),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Lock Icon in Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9F0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: Color(0xFFD2760A), // Warning/Orange color
              size: 28,
            ),
          ),
          const SizedBox(height: 18),

          const Text(
            'Complete your account setup',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.navy,
              fontFamily: 'DM Sans',
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Add your payment card to continue',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontFamily: 'DM Sans',
            ),
          ),
          const SizedBox(height: 20),

          // Chips Row
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildStatusChip('Email', emailVerified),
              _buildStatusChip('Phone', phoneVerified),
              _buildStatusChip('ID', idVerified),
              _buildStatusChip('Card', cardAdded),
            ],
          ),

          const SizedBox(height: 32),

          // Primary Button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: onCompleteSetup,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Complete Setup',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'DM Sans',
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Secondary Button
          GestureDetector(
            onTap: onNotNow,
            child: const Text(
              'Not Now',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'DM Sans',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, bool isCompleted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: !isCompleted
            ? Border.all(color: const Color(0xFFD2760A), width: 1.2)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isCompleted ? const Color(0xFF5B926C) : const Color(0xFFD2760A),
              fontFamily: 'DM Sans',
            ),
          ),
          const SizedBox(width: 4),
          Text(
            isCompleted ? '✓' : '!',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: isCompleted ? const Color(0xFF5B926C) : const Color(0xFFD2760A),
            ),
          ),
        ],
      ),
    );
  }
}
