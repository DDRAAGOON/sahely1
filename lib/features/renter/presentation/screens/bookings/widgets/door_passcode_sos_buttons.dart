import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class DoorPasscodeSosButtons extends StatelessWidget {
  final VoidCallback onDoorPasscodeTap;
  final VoidCallback onSOSTap;

  const DoorPasscodeSosButtons({
    super.key,
    required this.onDoorPasscodeTap,
    required this.onSOSTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Door Passcode Button
        Expanded(
          flex: 5,
          child: SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: onDoorPasscodeTap,
              icon: const Icon(Icons.lock_open_outlined,
                  size: 18, color: AppColors.navy),
              label: const Text(
                'Door Passcode',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                  fontFamily: 'DM Sans',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // SOS Button
        Expanded(
          flex: 3,
          child: SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: onSOSTap,
              icon: const Icon(Icons.warning_amber_rounded,
                  size: 18, color: Colors.white),
              label: const Text(
                'SOS',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFamily: 'DM Sans',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.sos,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
