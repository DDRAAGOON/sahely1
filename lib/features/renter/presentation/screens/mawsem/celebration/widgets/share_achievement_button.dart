import 'package:flutter/material.dart';

import '../../../../../../../../core/theme/app_colors.dart';

class ShareAchievementButton extends StatelessWidget {
  final VoidCallback onTap;

  const ShareAchievementButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Share achievement',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            fontFamily: 'DM Sans',
          ),
        ),
      ),
    );
  }
}
