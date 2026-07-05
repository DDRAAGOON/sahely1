import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class FilterDateBox extends StatelessWidget {
  const FilterDateBox(this.label, {super.key, this.onTap});
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.goldSoft,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 15, color: AppColors.gold),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  label,
                  style: AppTheme.dm(size: 13, color: AppColors.muted),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
}

class GuestStepRow extends StatelessWidget {
  const GuestStepRow(this.title, this.sub, this.value, {super.key, required this.onChanged});
  final String title;
  final String sub;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTheme.dm(size: 14)),
              Text(sub, style: AppTheme.dm(size: 11, color: AppColors.muted)),
            ],
          ),
          Row(
            children: [
              StepBtn(filled: false, onTap: () => onChanged(value > 0 ? value - 1 : 0)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text('$value', style: AppTheme.dm(size: 15, weight: FontWeight.w700)),
              ),
              StepBtn(filled: true, onTap: () => onChanged(value + 1)),
            ],
          ),
        ],
      ),
    );
  }
}

class StepBtn extends StatelessWidget {
  const StepBtn({super.key, required this.filled, this.onTap});
  final bool filled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: filled ? AppColors.navy : Colors.transparent,
            border: filled ? null : Border.all(color: AppColors.navy, width: 1.5),
            shape: BoxShape.circle,
          ),
          child: Icon(filled ? Icons.add : Icons.remove, size: 18, color: filled ? AppColors.white : AppColors.navy),
        ),
      );
}

class PriceSlider extends StatelessWidget {
  const PriceSlider({super.key, required this.values, required this.onChanged});
  final RangeValues values;
  final ValueChanged<RangeValues> onChanged;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: AppColors.gold,
        inactiveTrackColor: const Color(0xFFE5E0D3),
        trackHeight: 4,
        rangeThumbShape: const CustomRangeThumbShape(),
        overlayColor: AppColors.navy.withValues(alpha: 0.1),
      ),
      child: RangeSlider(
        values: values,
        min: 1000,
        max: 15000,
        onChanged: onChanged,
      ),
    );
  }
}

class CustomRangeThumbShape extends RangeSliderThumbShape {
  const CustomRangeThumbShape();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(22, 22);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool isOnTop = false,
    bool isPressed = false,
    required SliderThemeData sliderTheme,
    ui.TextDirection? textDirection,
    Thumb? thumb,
  }) {
    final Canvas canvas = context.canvas;

    final Paint whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Path path = Path()..addOval(Rect.fromCircle(center: center, radius: 11));
    canvas.drawShadow(path, Colors.black, 3, true);

    canvas.drawCircle(center, 11, whitePaint);

    final Paint navyPaint = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 8, navyPaint);
  }
}

class RuleToggle extends StatelessWidget {
  const RuleToggle(this.label, this.on, {super.key, required this.onChanged});
  final String label;
  final bool on;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTheme.dm(size: 13)),
          GestureDetector(
            onTap: () => onChanged(!on),
            child: Container(
              width: 42,
              height: 24,
              decoration: BoxDecoration(color: on ? AppColors.success : AppColors.border, borderRadius: BorderRadius.circular(12)),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: on ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(width: 20, height: 20, margin: const EdgeInsets.all(2), decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
