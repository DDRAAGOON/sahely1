import 'package:flutter/material.dart';

/// A round avatar placeholder: a person on a filled circle, the way every
/// messaging app shows someone with no photo.
///
/// [icon] can be swapped for a different glyph, or set to null for a plain
/// coloured circle.
class AvatarCircle extends StatelessWidget {
  const AvatarCircle({
    super.key,
    this.size = 40,
    this.colors = const [Color(0xFF7FA8BF), Color(0xFF2C5066)],
    this.icon = Icons.person,
  });

  final double size;
  final List<Color> colors;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final glyph = icon;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: glyph == null
          ? null
          : Icon(
              glyph,
              size: size * 0.55,
              color: Colors.white.withValues(alpha: 0.92),
            ),
    );
  }
}
