import 'package:flutter/material.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/kit.dart';

class SmartLockScreen extends StatelessWidget {
  final Property? property;
  final bool outOfRange;
  const SmartLockScreen({super.key, this.property, this.outOfRange = false});

  @override
  Widget build(BuildContext context) {
    final name = property?.name ?? 'Lagoon Retreat';

    return PhoneScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          TopBar(title: 'Smart Lock', subtitle: name),
          const SizedBox(height: 24),
          if (outOfRange)
            const _SmartLockOutOfRange()
          else
            const _SmartLockActive(),
          const SizedBox(height: 24),
          Text('Keypad Access', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
          const SizedBox(height: 10),
          WhiteCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Active Code', style: AppTheme.dm(size: 13, color: AppColors.muted)),
                  Text('Expires Jun 25, 11 AM', style: AppTheme.dm(size: 11, color: AppColors.muted)),
                ]),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var d in ['4', '8', '2', '9', '1', '7']) ...[
                      Container(
                        width: 38,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: AppColors.cream, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
                        child: Text(d, style: AppTheme.dm(size: 20, weight: FontWeight.w700, color: AppColors.navy)),
                      ),
                      if (d != '7') const SizedBox(width: 8),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                const WideButton(label: 'Copy to clipboard', icon: Icons.copy, color: AppColors.navy, outline: true, height: 42),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Instructions', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
          const SizedBox(height: 10),
          WhiteCard(
            padding: const EdgeInsets.all(14),
            child: Column(children: [
              _instructionRow('1', 'Approach the door and wake up the keypad.'),
              _instructionRow('2', 'Enter the 6-digit code above.'),
              _instructionRow('3', 'Wait for the green light and turn the handle.'),
              _instructionRow('4', 'To lock, just press the lock button on the keypad.', last: true),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _instructionRow(String num, String text, {bool last = false}) => Padding(
    padding: EdgeInsets.only(bottom: last ? 0 : 12),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(width: 20, height: 20, alignment: Alignment.center, decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle), child: Text(num, style: AppTheme.dm(size: 11, weight: FontWeight.w700, color: AppColors.navy))),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: AppTheme.dm(size: 13, color: AppColors.ink, height: 1.4))),
    ]),
  );
}

class _SmartLockActive extends StatelessWidget {
  const _SmartLockActive();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white,
          border: Border.all(color: AppColors.success, width: 8),
          boxShadow: [BoxShadow(color: AppColors.success.withValues(alpha: 0.1), blurRadius: 20, spreadRadius: 5)],
        ),
        child: const Icon(Icons.lock_open, size: 64, color: AppColors.success),
      ),
      const SizedBox(height: 20),
      Text('Unlocked', style: AppTheme.dm(size: 20, weight: FontWeight.w700, color: AppColors.success)),
      const SizedBox(height: 6),
      Text('Bluetooth connected · Signal strong', style: AppTheme.dm(size: 13, color: AppColors.muted)),
    ]);
  }
}

class _SmartLockOutOfRange extends StatelessWidget {
  const _SmartLockOutOfRange();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white,
          border: Border.all(color: AppColors.danger, width: 8),
          boxShadow: [BoxShadow(color: AppColors.danger.withValues(alpha: 0.1), blurRadius: 20, spreadRadius: 5)],
        ),
        child: const Icon(Icons.location_off_outlined, size: 64, color: AppColors.danger),
      ),
      const SizedBox(height: 20),
      Text('Too Far from Door', style: AppTheme.dm(size: 20, weight: FontWeight.w700, color: AppColors.danger)),
      const SizedBox(height: 6),
      Text('Unlock via app is only available within 50 meters.', textAlign: TextAlign.center, style: AppTheme.dm(size: 13, color: AppColors.muted)),
      const SizedBox(height: 12),
      Text('Use the keypad code below instead.', style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.navy)),
    ]);
  }
}
