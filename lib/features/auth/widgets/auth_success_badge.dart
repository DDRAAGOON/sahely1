import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';

/// Animated auth success badge matching the Sahely design system
/// (screen 12 · Verification Complete): navy badge pops in once, a gold ring
/// ripples outward forever (`sahRingOut`), and the shield + check strokes
/// draw themselves in.
class AuthSuccessBadge extends StatefulWidget {
  const AuthSuccessBadge({super.key, required this.navy});

  final bool navy;

  @override
  State<AuthSuccessBadge> createState() => _AuthSuccessBadgeState();
}

/// sahPop keyframes from the design CSS, as a clamped piecewise function
/// (a TweenSequence driven by an overshooting curve asserts on t > 1).
double _popScale(double t) {
  t = t.clamp(0.0, 1.0);
  const seg1 = 0.55, seg2 = 0.75;
  if (t <= seg1) {
    return 0.40 + (1.12 - 0.40) * Curves.easeOut.transform(t / seg1);
  } else if (t <= seg2) {
    final k = (t - seg1) / (seg2 - seg1);
    return 1.12 + (0.96 - 1.12) * Curves.easeInOut.transform(k);
  }
  return 0.96 + (1.00 - 0.96) * Curves.easeOut.transform((t - seg2) / (1 - seg2));
}

class _AuthSuccessBadgeState extends State<AuthSuccessBadge>
    with TickerProviderStateMixin {
  /// Badge pop-in (runs once).
  late final AnimationController _pop = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700));

  /// Ripple ring loop (like `.sah-ring`, 1.8s infinite).
  late final AnimationController _ring = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
      value: 0.35)
    ..repeat();

  /// Stroke draw-in for the shield + check.
  late final AnimationController _draw = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 600));

  @override
  void initState() {
    super.initState();
    _pop.forward();
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) _draw.forward();
    });
  }

  @override
  void dispose() {
    _pop.dispose();
    _ring.dispose();
    _draw.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Design: 108px navy circle (screen 12); gold variant kept slightly larger.
    final size = widget.navy ? 108.0 : 124.0;

    return SizedBox(
      width: size * 2.1,
      height: size * 2.1,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // ---- Expanding ripple ring ----
          AnimatedBuilder(
              animation: _ring,
              builder: (_, __) {
                final t =
                    Curves.easeOut.transform(_ring.value.clamp(0.0, 1.0));
                return Container(
                  width: size * (0.7 + t * 1.4),
                  height: size * (0.7 + t * 1.4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.55 * (1 - t)),
                      width: 3,
                    ),
                  ),
                );
              }),
          // ---- Badge (pops in) ----
          AnimatedBuilder(
              animation: Listenable.merge([_pop, _draw]),
              builder: (_, __) {
                return Transform.scale(
                  scale: _popScale(_pop.value),
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: widget.navy
                          ? null
                          : const RadialGradient(
                              center: Alignment(0, -0.2),
                              colors: [AppColors.goldBright, AppColors.gold]),
                      color: widget.navy ? AppColors.navy : null,
                      boxShadow: [
                        BoxShadow(
                            color:
                                (widget.navy ? AppColors.navy : AppColors.gold)
                                    .withValues(alpha: 0.35),
                            blurRadius: widget.navy ? 34 : 30,
                            offset: const Offset(0, 12)),
                      ],
                    ),
                    child: Center(
                      // The design's shield SVG is 52px inside a 108px circle.
                      child: SizedBox(
                        width: size * 0.48,
                        height: size * 0.48,
                        child: widget.navy
                            ? CustomPaint(
                                painter: _ShieldCheckPainter(progress: _draw))
                            : CustomPaint(
                                painter:
                                    _PlainCheckPainter(progress: _draw)),
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}

/// Gold shield outline + check, drawn progressively (24×24 viewBox paths).
/// Stroke widths are in viewBox units so they scale with the badge.
class _ShieldCheckPainter extends CustomPainter {
  _ShieldCheckPainter({required this.progress});

  final Animation<double> progress;

  static final Path _shield = Path()
    ..moveTo(12, 2)
    ..lineTo(19, 5)
    ..lineTo(19, 11)
    ..cubicTo(19, 16, 15.5, 19, 12, 20)
    ..cubicTo(8.5, 19, 5, 16, 5, 11)
    ..lineTo(5, 5)
    ..close();

  static final Path _check = Path()
    ..moveTo(9, 12)
    ..lineTo(11, 14)
    ..lineTo(15, 10);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    canvas.save();
    canvas.scale(size.width / 24, size.height / 24);

    // Shield draws over the first ~70% of the animation…
    final shieldT = Curves.easeOut
        .transform((progress.value / 0.7).clamp(0.0, 1.0));
    // …the check draws over the last half, overlapping slightly.
    final checkT = Curves.easeOut
        .transform(((progress.value - 0.5) / 0.5).clamp(0.0, 1.0));

    final paint = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (final (path, t, w) in [(_shield, shieldT, 2.0), (_check, checkT, 2.2)]) {
      if (t <= 0) continue;
      final metric = path.computeMetrics().first;
      paint.strokeWidth = w;
      canvas.drawPath(metric.extractPath(0, metric.length * t), paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ShieldCheckPainter old) =>
      old.progress.value != progress.value;
}

/// Simple white check draw used on the gold variant.
class _PlainCheckPainter extends CustomPainter {
  _PlainCheckPainter({required this.progress});

  final Animation<double> progress;

  static final Path _path = Path()
    ..moveTo(5, 13)
    ..lineTo(9, 17)
    ..lineTo(19, 7);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || progress.value <= 0) return;
    canvas.save();
    canvas.scale(size.width / 24, size.height / 24);
    final metric = _path.computeMetrics().first;
    final partial = metric.extractPath(0,
        metric.length * Curves.easeOut.transform(progress.value.clamp(0.0, 1.0)));
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(partial, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PlainCheckPainter old) =>
      old.progress.value != progress.value;
}
