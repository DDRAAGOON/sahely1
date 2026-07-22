import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/sheet_handle.dart';

class ShareEarnScreen extends StatelessWidget {
  const ShareEarnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      bg: const LinearGradient(colors: [AppColors.navy, AppColors.navy]),
      sheetColor: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SheetHandle(),
          const SizedBox(height: 8),
          Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color(0xFFFEDA77),
                    Color(0xFFF58529),
                    Color(0xFFDD2A7B),
                    Color(0xFF8134AF)
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.camera_alt_outlined,
                  color: Colors.white, size: 32)),
          const SizedBox(height: 16),
          Text("You're checked in 🎉",
              style: AppTheme.dm(
                  size: 20, weight: FontWeight.w700, color: AppColors.navy)),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: AppTheme.dm(
                        size: 14, color: AppColors.muted, height: 1.5),
                    children: const [
                      TextSpan(text: 'Post a Story or Reel from '),
                      TextSpan(
                          text: 'Lagoon Retreat',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink)),
                      TextSpan(text: ' and tag '),
                      TextSpan(
                          text: '@sahelyeg',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFB0468A))),
                      TextSpan(text: ' — keep it up 24h to earn stars.'),
                    ])),
          ),
          const SizedBox(height: 16),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                  color: const Color(0xFFFBF3DE),
                  border: Border.all(color: const Color(0xFFEAD9A8)),
                  borderRadius: BorderRadius.circular(20)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.star, size: 16, color: AppColors.gold),
                const SizedBox(width: 6),
                Text('Earn +5 Sahel Stars',
                    style: AppTheme.dm(
                        size: 14,
                        weight: FontWeight.w700,
                        color: const Color(0xFF9A7A22)))
              ])),
          const SizedBox(height: 18),
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
                height: 52,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Color(0xFFF58529),
                      Color(0xFFDD2A7B),
                      Color(0xFF8134AF)
                    ]),
                    borderRadius: BorderRadius.circular(12)),
                alignment: Alignment.center,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.camera_alt_outlined,
                      size: 18, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Share to Instagram',
                      style: AppTheme.dm(
                          size: 15,
                          weight: FontWeight.w700,
                          color: Colors.white))
                ])),
          ),
          const SizedBox(height: 14),
          GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: Text('Maybe later',
                  style: AppTheme.dm(size: 13, color: AppColors.muted))),
        ],
      ),
    );
  }
}

class _SheetScaffold extends StatelessWidget {
  const _SheetScaffold(
      {required this.child, required this.bg, this.sheetColor});

  final Widget child;
  final Gradient bg;
  final Color? sheetColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        Positioned.fill(
            child: DecoratedBox(decoration: BoxDecoration(gradient: bg))),
        const Positioned.fill(child: ColoredBox(color: Color(0x8C0B101C))),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
                color: sheetColor ?? const Color(0xF5F5F0E8),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24))),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 26),
            child: SafeArea(top: false, child: child),
          ),
        ),
      ]),
    );
  }
}
