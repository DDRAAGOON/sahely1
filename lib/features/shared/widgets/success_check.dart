import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class SuccessCheck extends StatefulWidget {
  const SuccessCheck({super.key, this.color = const Color(0xFF1B6B3A), this.size = 96, this.gold = false});
  final Color color;
  final double size;
  final bool gold;

  @override
  State<SuccessCheck> createState() => _SuccessCheckState();
}

class _SuccessCheckState extends State<SuccessCheck> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.gold ? AppColors.gold : widget.color;
    return SizedBox(
      width: widget.size + 24,
      height: widget.size + 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _c,
            builder: (_, __) => Container(
              width: widget.size * (0.75 + _c.value * 1.3),
              height: widget.size * (0.75 + _c.value * 1.3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: c.withOpacity(0.5 * (1 - _c.value)), width: 3),
              ),
            ),
          ),
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: widget.gold
                  ? const RadialGradient(center: Alignment(0, -0.2), colors: [AppColors.goldLight, AppColors.gold])
                  : RadialGradient(center: const Alignment(0, -0.2), colors: [c, Color.lerp(c, Colors.black, 0.18)!]),
              boxShadow: [BoxShadow(color: c.withOpacity(0.4), blurRadius: 30, offset: const Offset(0, 12))],
            ),
            child: const Icon(Icons.check, color: AppColors.white, size: 46),
          ),
        ],
      ),
    );
  }
}
