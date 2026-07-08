import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../widgets/sheet_handle.dart';
import '../widgets/tags.dart';

class BlockedGateScreen extends StatelessWidget {
  const BlockedGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        const Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF7FA8BF), Color(0xFF2C5066)])))),
        const Positioned.fill(child: ColoredBox(color: Color(0x8C1B2744))),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: const BoxDecoration(color: AppColors.cream, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: SafeArea(
              top: false,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const SheetHandle(),
                const SizedBox(height: 8),
                Container(width: 52, height: 52, decoration: BoxDecoration(color: const Color(0xFFFEF4E8), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.lock_outline, color: Color(0xFFD2760A))),
                const SizedBox(height: 14),
                Text('Complete your account setup', textAlign: TextAlign.center, style: AppTheme.dm(size: 18, weight: FontWeight.w700, color: AppColors.navy)),
                const SizedBox(height: 6),
                Text('Add your payment card to continue', style: AppTheme.dm(size: 13, color: AppColors.muted)),
                const SizedBox(height: 16),
                const Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: [
                  Pill('Email ✓', bg: AppColors.white, fg: AppColors.success),
                  Pill('Phone ✓', bg: AppColors.white, fg: AppColors.success),
                  Pill('ID ✓', bg: AppColors.white, fg: AppColors.success),
                  Pill('Card !', bg: Color(0xFFFEF4E8), fg: Color(0xFFD2760A), border: Color(0xFFD2760A)),
                ]),
                const SizedBox(height: 18),
                NavyButton(label: 'Complete Setup', onTap: () => Navigator.pushReplacementNamed(context, '/add-card')),
                const SizedBox(height: 10),
                GestureDetector(onTap: () => Navigator.maybePop(context), child: Text('Not Now', style: AppTheme.dm(size: 13, color: AppColors.muted))),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}
