import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage fadeSlideTransition({
  required LocalKey key,
  required Widget child,
  Offset begin = const Offset(0.05, 0),
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: begin,
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      );
    },
  );
}
