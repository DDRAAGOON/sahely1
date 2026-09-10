import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';

/// Animated success circle matching the Sahely design system:
///  1. The badge pops in once with an overshoot bounce (`sahPop`).
///  2. A ring ripples outward forever (`sahRingOut`: scale .7 → 2.1, fade).
///  3. The check mark draws itself in a short stroke animation (`sahDraw`),
///     rendered inside a ~48% box exactly like the design's inline SVG.
class SuccessCheck extends StatefulWidget {
  const SuccessCheck(
      {super.key,
      this.color = const Color(0xFF1B6B3A),
      this.size = 96,
      this.gold = false,
      this.checkColor,
      this.linearGradient = false,
      this.glow = false});

  final Color color;
  final double size;
  final bool gold;

  /// Check stroke color; defaults to white (design uses navy on screen 27).
  final Color? checkColor;

  /// Screen 27 style: linear gold gradient instead of a radial one.
  final bool linearGradient;

  /// Screen 27 style: soft outer glow (0 0 50px) instead of a drop shadow.
  final bool glow;

  @override
  State<SuccessCheck> createState() => _SuccessCheckState();
}

/// sahPop keyframes from the design CSS:
///   0% scale(.4) → 55% scale(1.12) → 75% scale(.96) → 100% scale(1).
/// Implemented as a clamped piecewise function so no tween can ever receive
/// an out-of-range t (the old TweenSequence + easeOutBack combo asserted).
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

class _SuccessCheckState extends State<SuccessCheck>
    with TickerProviderStateMixin {
  /// Badge pop-in: runs once on entrance.
  late final AnimationController _pop = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700));

  /// Ripple ring: expands and fades forever, like `.sah-ring`.
  late final AnimationController _ring = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
      value: 0.35 // head start so the first ripple is visible early.
      )
    ..repeat();

  /// Check stroke draw: starts slightly after the badge lands.
  late final AnimationController _draw = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));

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
    final c = widget.gold ? AppColors.gold : widget.color;
    final s = widget.size;

    return SizedBox(
      width: s * 2.2,
      height: s * 2.2,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // ---- Expanding ripple ring ----
          AnimatedBuilder(
              animation: _ring,
              builder: (_, __) {
                final t = Curves.easeOut.transform(_ring.value.clamp(0.0, 1.0));
                return Container(
                  width: s * (0.7 + t * 1.4), // scale(.7) → 2.1x of base
                  height: s * (0.7 + t * 1.4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: c.withValues(alpha: 0.55 * (1 - t)),
                      width: 3,
                    ),
                  ),
                );
              }),
          // ---- Badge (pops in) ----
          AnimatedBuilder(
              animation: _pop,
              builder: (_, __) {
                return Transform.scale(
                  scale: _popScale(_pop.value),
                  child: Container(
                    width: s,
                    height: s,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: _badgeGradient(c),
                      boxShadow: [
                        if (widget.glow)
                          BoxShadow(
                              color: c.withValues(alpha: 0.5),
                              blurRadius: 50,
                              spreadRadius: 0)
                        else
                          BoxShadow(
                              color: c.withValues(alpha: 0.4),
                              blurRadius: 28,
                              offset: const Offset(0, 10)),
                      ],
                    ),
                    child: Center(
                      // The design draws its check SVG at ~48% of the badge
                      // (e.g. 46px inside a 96px circle).
                      child: SizedBox(
                        width: s * 0.48,
                        height: s * 0.48,
                        child: CustomPaint(
                          painter: _CheckPainter(
                              color: widget.checkColor ?? Colors.white,
                              progress: _draw),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }

  Gradient _badgeGradient(Color c) {
    if (widget.gold && widget.linearGradient) {
      // Screen 27: linear-gradient(150deg, #E4C56A, #C9A84C)
      return const LinearGradient(
        begin: Alignment(-0.35, -1.0),
        end: Alignment(0.35, 1.0),
        colors: [AppColors.goldBright, AppColors.gold],
      );
    }
    if (widget.gold) {
      // Screens 20/38-style: radial-gradient(circle at 50% 40%, bright, base)
      return const RadialGradient(
          center: Alignment(0, -0.2), colors: [AppColors.goldBright, AppColors.gold]);
    }
    // Green badges (screens 28/38): brighter core fading to the base color,
    // e.g. radial-gradient(circle at 50% 38%, #28a85f, #1B6B3A).
    return RadialGradient(
      center: const Alignment(0, -0.24),
      colors: [Color.lerp(c, Colors.white, 0.32)!, c],
    );
  }
}

/// Draws "M5 13l4 4L19 7" progressively inside its box, mimicking the SVG
/// stroke-dash animation in the design (`sahDraw`). Stroke widths are given
/// in viewBox units so they scale proportionally with the badge size.
class _CheckPainter extends CustomPainter {
  _CheckPainter({required this.color, required this.progress});

  final Color color;
  final Animation<double> progress;

  static final Path _path = Path()
    ..moveTo(5, 13)
    ..lineTo(9, 17)
    ..lineTo(19, 7);

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress.value;
    if (t <= 0 || size.isEmpty) return;

    canvas.save();
    canvas.scale(size.width / 24, size.height / 24);

    final metric = _path.computeMetrics().first;
    final partial = metric.extractPath(
        0, metric.length * Curves.easeOut.transform(t.clamp(0.0, 1.0)));

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(partial, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CheckPainter old) =>
      old.progress.value != progress.value || old.color != color;
}
