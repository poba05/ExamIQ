import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  final Widget child;
  final dynamic height;
  final dynamic width;
  const GradientContainer({
    super.key,
    required this.child,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height,
          width: width.toDouble(),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // stops: [0.1, 0.5, 0.9],
              colors: [
                Colors.blue.shade50,
                Colors.pink.shade50,
                // Colors.purple.shade50,
              ],
            ),
          ),
          child: child,
        ),
        Positioned(
          top: -100,
          right: -80,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
