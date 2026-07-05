import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class PasswordStrengthMeter extends StatelessWidget {
  final String password;

  const PasswordStrengthMeter({
    super.key,
    required this.password,
  });

  int _calculateStrength(String password) {
    if (password.isEmpty) return 0;

    int strength = 0;

    // Length check
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;

    // Complexity checks
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;

    // Normalize to 0-4 scale
    if (strength <= 1) return 1;
    if (strength <= 3) return 2;
    if (strength <= 5) return 3;
    return 4;
  }

  String _getStrengthText(int strength) {
    switch (strength) {
      case 1:
        return 'Weak password';
      case 2:
        return 'Fair password';
      case 3:
        return 'Good password';
      case 4:
        return 'Strong password';
      default:
        return '';
    }
  }

  Color _getStrengthColor(int strength) {
    switch (strength) {
      case 1:
        return AppColors.red;
      case 2:
        return AppColors.warning;
      case 3:
        return const Color(0xFFD2760A); // Orange
      case 4:
        return AppColors.green;
      default:
        return AppColors.border;
    }
  }

  @override
  Widget build(BuildContext context) {
    final strength = _calculateStrength(password);
    final strengthText = _getStrengthText(strength);
    final strengthColor = _getStrengthColor(strength);

    if (password.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        // Strength Bars
        Row(
          children: List.generate(4, (index) {
            final isActive = index < strength;
            return Expanded(
              child: Container(
                height: 4,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: isActive ? strengthColor : AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 6),

        // Strength Text
        Text(
          strengthText,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: strengthColor,
            fontFamily: 'DM Sans',
          ),
        ),
      ],
    );
  }
}
