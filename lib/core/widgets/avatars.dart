import 'package:flutter/material.dart';

class AvatarCircle extends StatelessWidget {
  const AvatarCircle(
      {super.key,
      this.size = 40,
      this.colors = const [Color(0xFF7FA8BF), Color(0xFF2C5066)],
      this.icon});

  final double size;
  final List<Color> colors;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: icon != null
          ? Icon(icon, size: size * 0.5, color: Colors.white) : null,
    );
  }
}
