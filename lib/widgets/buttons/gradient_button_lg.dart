import 'package:flutter/material.dart';

class GradientButtonLg extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final int horizontalPadding;
  final int verticalPadding;
  const GradientButtonLg({
    super.key,
    required this.child,
    required this.onPressed,
    required this.horizontalPadding,
    required this.verticalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding.toDouble(),
            vertical: verticalPadding.toDouble(),
          ),
        ),
        child: child,
      ),
    );
  }
}
