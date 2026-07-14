import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/cream_background.dart';
import '../../../core/widgets/ui.dart';

// ======================================================== 11 · Facial Scan
class FacialScanScreen extends StatefulWidget {
  const FacialScanScreen({super.key});
  @override
  State<FacialScanScreen> createState() => _FacialScanScreenState();
}

class _FacialScanScreenState extends State<FacialScanScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 2200))..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    return PhoneScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 6, 24, 30),
        child: Column(
          children: [
            _SelfieStepBar(),
            const SizedBox(height: 18),
            Text('Take a Live Selfie', style: AppTheme.dm(size: 22, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 6),
            Text("We'll match your face to your ID — live only",
                style: AppTheme.dm(size: 13, color: AppColors.muted)),
            const SizedBox(height: 18),
            SizedBox(
              width: 252,
              height: 372,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.elliptical(252, 372)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFEEF1F5), Color(0xFFE2E8EF)],
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _c,
                    builder: (_, child) => Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.elliptical(252, 372)),
                        border: Border.all(color: AppColors.gold, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gold.withValues(alpha: 0.35 + 0.35 * _c.value),
                            blurRadius: 14 + 16 * _c.value,
                            spreadRadius: 2 + 7 * _c.value,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Icon(Icons.person, size: 120, color: Color(0xFF9AA6B4)),
                ],
              ),
            ),
            const Spacer(),
            Text('Hold still — capture happens automatically, live only',
                textAlign: TextAlign.center, style: AppTheme.dm(size: 13, color: AppColors.muted)),
            const SizedBox(height: 12),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _SelfieTip('Good lighting'),
                _SelfieTip('Look at the camera'),
                _SelfieTip('No glasses'),
                _SelfieTip('No hats'),
                _SelfieTip('No mask'),
              ],
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => Navigator.pushReplacementNamed(context, '/verification-complete', arguments: args),
              child: Text('Simulate capture',
                  style: AppTheme.dm(size: 12, weight: FontWeight.w600, color: AppColors.gold)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelfieStepBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget done() => Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
          child: const Icon(Icons.check, size: 11, color: AppColors.navy),
        );
    return Row(
      children: [
        done(),
        Expanded(child: Container(height: 2, margin: const EdgeInsets.symmetric(horizontal: 8), color: AppColors.gold)),
        done(),
        Expanded(child: Container(height: 2, margin: const EdgeInsets.symmetric(horizontal: 8), color: AppColors.gold)),
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: const BoxDecoration(color: AppColors.navy, shape: BoxShape.circle),
          child: Text('3', style: AppTheme.dm(size: 11, color: AppColors.white)),
        ),
        const SizedBox(width: 6),
        Text('Selfie', style: AppTheme.dm(size: 12, weight: FontWeight.w600, color: AppColors.navy)),
      ],
    );
  }
}

class _SelfieTip extends StatelessWidget {
  const _SelfieTip(this.label);
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(label, style: AppTheme.dm(size: 12, color: AppColors.ink)),
        ],
      ),
    );
  }
}
