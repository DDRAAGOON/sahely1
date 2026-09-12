import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The AL MAWSEM night-beach artwork used behind the season cards: the moon
/// over the sea, palm silhouettes and the shoreline, as on the web app.
///
/// It is painted instead of shipped as an image so it stays sharp at every
/// card size and adds nothing to the bundle. Drop it into a [Stack] with
/// [Positioned.fill]; it already dims itself on the left so the card's text
/// keeps its contrast.
class MawsemSceneBackground extends StatelessWidget {
  const MawsemSceneBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const RepaintBoundary(
      child: CustomPaint(
        painter: _MawsemScenePainter(),
        isComplex: true,
        willChange: false,
      ),
    );
  }
}

class _MawsemScenePainter extends CustomPainter {
  const _MawsemScenePainter();

  static const _skyTop = Color(0xFF0A1626);
  static const _skyHorizon = Color(0xFF16324E);
  static const _seaTop = Color(0xFF102B46);
  static const _seaBottom = Color(0xFF07131F);
  static const _sand = Color(0xFF060E1A);
  static const _silhouette = Color(0xFF020609);
  static const _moon = Color(0xFFE8F2FA);
  static const _moonGlow = Color(0xFF7FB3D8);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    if (w <= 0 || h <= 0) return;
    canvas.clipRect(Offset.zero & size);

    // The scene is drawn at the scale of a wide banner and anchored to the
    // bottom, so a tall card gets more sky rather than a giant moon.
    final unit = h < w * 0.55 ? h : w * 0.55;
    final horizon = h - unit * 0.40;
    // Kept to the right, clear of the card's own text.
    final moon = Offset(w * 0.78, horizon - unit * 0.34);

    _sky(canvas, w, horizon);
    _moonlight(canvas, moon, unit * 0.13, unit);
    _birds(canvas, w, horizon, unit);
    _sailboat(canvas, w, horizon, unit);
    _sea(canvas, w, h, horizon);
    _reflection(canvas, moon.dx, horizon, w, unit);
    _shore(canvas, w, h, horizon, unit);
    _umbrella(canvas, Offset(w * 0.30, horizon + unit * 0.26), unit * 0.09);
    _palm(canvas, Offset(w * 0.11, h + unit * 0.02), unit * 0.95, 1);
    _palm(canvas, Offset(w * 0.19, h + unit * 0.02), unit * 0.72, -1);
    _scrim(canvas, w, h);
  }

  void _sky(Canvas canvas, double w, double horizon) {
    final rect = Rect.fromLTRB(0, 0, w, horizon);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_skyTop, _skyHorizon],
        ).createShader(rect),
    );
  }

  void _moonlight(Canvas canvas, Offset centre, double radius, double unit) {
    final glow = unit * 0.62;
    canvas.drawCircle(
      centre,
      glow,
      Paint()
        ..shader = RadialGradient(
          colors: [
            _moonGlow.withValues(alpha: 0.30),
            _moonGlow.withValues(alpha: 0.12),
            _moonGlow.withValues(alpha: 0.04),
            _moonGlow.withValues(alpha: 0),
          ],
          stops: const [0.0, 0.30, 0.60, 1.0],
        ).createShader(Rect.fromCircle(center: centre, radius: glow)),
    );
    canvas.drawCircle(
      centre,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            _moon.withValues(alpha: 0.85),
            _moon.withValues(alpha: 0.55),
          ],
        ).createShader(Rect.fromCircle(center: centre, radius: radius)),
    );
  }

  /// Three gulls, each a stroked pair of wings.
  void _birds(Canvas canvas, double w, double horizon, double unit) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1, unit * 0.008)
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.30);
    void gull(Offset at, double span) {
      canvas.drawPath(
        Path()
          ..moveTo(at.dx - span, at.dy)
          ..quadraticBezierTo(
              at.dx - span * 0.5, at.dy - span * 0.6, at.dx, at.dy)
          ..quadraticBezierTo(
              at.dx + span * 0.5, at.dy - span * 0.6, at.dx + span, at.dy),
        paint,
      );
    }

    gull(Offset(w * 0.58, horizon - unit * 0.62), unit * 0.05);
    gull(Offset(w * 0.65, horizon - unit * 0.74), unit * 0.04);
    gull(Offset(w * 0.70, horizon - unit * 0.56), unit * 0.032);
  }

  void _sailboat(Canvas canvas, double w, double horizon, double unit) {
    final paint = Paint()..color = _silhouette.withValues(alpha: 0.85);
    final base = Offset(w * 0.40, horizon);
    final sail = unit * 0.10;
    canvas.drawPath(
      Path()
        ..moveTo(base.dx, base.dy - sail)
        ..lineTo(base.dx + sail * 0.42, base.dy)
        ..lineTo(base.dx - sail * 0.10, base.dy)
        ..close(),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(base.dx - sail * 0.34, base.dy)
        ..lineTo(base.dx + sail * 0.52, base.dy)
        ..lineTo(base.dx + sail * 0.30, base.dy + sail * 0.14)
        ..lineTo(base.dx - sail * 0.18, base.dy + sail * 0.14)
        ..close(),
      paint,
    );
  }

  void _sea(Canvas canvas, double w, double h, double horizon) {
    final rect = Rect.fromLTRB(0, horizon, w, h);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_seaTop, _seaBottom],
        ).createShader(rect),
    );
  }

  /// The moon's path on the water: a few short bars under the horizon.
  void _reflection(
      Canvas canvas, double centreX, double horizon, double w, double unit) {
    final paint = Paint();
    const widths = [0.16, 0.13, 0.10, 0.07];
    for (var i = 0; i < widths.length; i++) {
      final y = horizon + unit * (0.05 + i * 0.07);
      final half = w * widths[i] / 2;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(centreX - half, y, centreX + half, y + unit * 0.018),
          Radius.circular(unit * 0.009),
        ),
        paint..color = _moon.withValues(alpha: 0.18 - i * 0.035),
      );
    }
  }

  /// The beach in the lower-left corner.
  void _shore(Canvas canvas, double w, double h, double horizon, double unit) {
    final shore = horizon + unit * 0.13;
    canvas.drawPath(
      Path()
        ..moveTo(0, shore)
        ..quadraticBezierTo(
            w * 0.16, shore + unit * 0.05, w * 0.34, shore + unit * 0.40)
        ..quadraticBezierTo(w * 0.44, shore + unit * 0.60, w * 0.58, h)
        ..lineTo(0, h)
        ..close(),
      Paint()..color = _sand,
    );
  }

  void _umbrella(Canvas canvas, Offset base, double size) {
    final paint = Paint()..color = _silhouette.withValues(alpha: 0.8);
    canvas.drawRect(
      Rect.fromLTWH(base.dx - size * 0.03, base.dy - size, size * 0.06, size),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(base.dx - size * 0.45, base.dy - size * 0.82)
        ..quadraticBezierTo(base.dx, base.dy - size * 1.35,
            base.dx + size * 0.45, base.dy - size * 0.82)
        ..close(),
      paint,
    );
  }

  /// One palm: a leaning trunk topped with drooping fronds. [lean] is 1 for a
  /// tree bending right, -1 for one bending left.
  void _palm(Canvas canvas, Offset base, double height, double lean) {
    final paint = Paint()..color = _silhouette;
    final top = Offset(base.dx + lean * height * 0.16, base.dy - height);
    final bend =
        Offset(base.dx + lean * height * 0.01, base.dy - height * 0.55);
    final trunk = height * 0.035;

    canvas.drawPath(
      Path()
        ..moveTo(base.dx - trunk, base.dy)
        ..quadraticBezierTo(
            bend.dx - trunk * 0.6, bend.dy, top.dx - trunk * 0.28, top.dy)
        ..lineTo(top.dx + trunk * 0.28, top.dy)
        ..quadraticBezierTo(
            bend.dx + trunk * 0.9, bend.dy, base.dx + trunk, base.dy)
        ..close(),
      paint,
    );

    const angles = [-2.95, -2.45, -1.95, -1.35, -0.75, -0.25, 0.25];
    final frond = height * 0.34;
    for (final angle in angles) {
      final direction = Offset(math.cos(angle) * lean, math.sin(angle));
      final tip = top + direction * frond + Offset(0, frond * 0.38);
      final mid = top + direction * (frond * 0.55) - Offset(0, frond * 0.10);
      canvas.drawPath(
        Path()
          ..moveTo(top.dx, top.dy)
          ..quadraticBezierTo(mid.dx, mid.dy, tip.dx, tip.dy)
          ..quadraticBezierTo(mid.dx, mid.dy + frond * 0.22, top.dx, top.dy)
          ..close(),
        paint,
      );
    }
  }

  /// Keeps the card's text readable: the scene stays visible on the right and
  /// fades into the card colour on the left and along the bottom.
  void _scrim(Canvas canvas, double w, double h) {
    final rect = Rect.fromLTWH(0, 0, w, h);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            _skyTop.withValues(alpha: 0.72),
            _skyTop.withValues(alpha: 0.40),
            _skyTop.withValues(alpha: 0.12),
          ],
          stops: const [0.0, 0.48, 1.0],
        ).createShader(rect),
    );
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            _skyTop.withValues(alpha: 0.45),
          ],
          stops: const [0.60, 1.0],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant _MawsemScenePainter oldDelegate) => false;
}
