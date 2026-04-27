import 'package:flutter/material.dart';
import 'dart:math';

class PageTransitions {
  static Route slide3D(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 700),
      reverseTransitionDuration: const Duration(milliseconds: 700),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
             final value = 1.0 - CurvedAnimation(parent: animation, curve: Curves.easeOutCubic).value;
             final transform = Matrix4.identity()
                 ..setEntry(3, 2, 0.0015) 
                 ..translate(0.0, 50.0 * value, value * -200)
                 ..rotateX(value * (pi / 8))
                 ..scale(1.0 - (value * 0.1));

             return Transform(
               transform: transform,
               alignment: Alignment.center,
               child: Opacity(
                 opacity: (1.0 - value).clamp(0.0, 1.0),
                 child: child,
               )
             );
          },
          child: child,
        );
      },
    );
  }
}
