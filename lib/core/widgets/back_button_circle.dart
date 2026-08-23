import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/widgets/bouncy_button.dart';

class BackButtonCircle extends StatelessWidget {
  final VoidCallback? onPressed;

  const BackButtonCircle({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BouncyButton(
      onTap: onPressed ?? () => Navigator.maybePop(context),
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}
