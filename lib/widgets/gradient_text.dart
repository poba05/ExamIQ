import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;
  final int fontSize;
  final double? height;
  const GradientText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        colors: [Colors.blue, Colors.purple],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize.toDouble(),
          fontWeight: FontWeight.bold,
          fontFamily: "sans-serif",
          height: height,
        ),
      ),
    );
  }
}
