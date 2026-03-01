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
    return Container(
      height: height.toDouble(),
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
    );
  }
}
