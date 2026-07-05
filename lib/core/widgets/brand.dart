import 'package:flutter/material.dart';

/// Sahely peak-and-sun logo. [light] = the cream/gold variant for dark
/// backgrounds; otherwise the navy variant.
class SahelyLogo extends StatelessWidget {
  const SahelyLogo({super.key, this.size = 56, this.light = true});
  final double size;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      light ? 'assets/images/sahely-logo-light.png' : 'assets/images/sahely-logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
