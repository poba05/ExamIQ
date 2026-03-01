import 'package:flutter/material.dart';

class BasicButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final int horizontalPadding;
  final int verticalPadding;
  const BasicButton({
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
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          top: BorderSide(color: Colors.grey.shade300, width: 1),
          left: BorderSide(color: Colors.grey.shade300, width: 1),
          right: BorderSide(color: Colors.grey.shade300, width: 1),
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
