import 'package:flutter/material.dart';

class Hover3dEffect extends StatefulWidget {
  final Widget child;
  final double depth;
  final double scale;

  const Hover3dEffect({super.key, required this.child, this.depth = 15.0, this.scale = 1.02});

  @override
  State<Hover3dEffect> createState() => _Hover3dEffectState();
}

class _Hover3dEffectState extends State<Hover3dEffect> {
  double x = 0;
  double y = 0;
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() {
        isHovered = false;
        x = 0;
        y = 0;
      }),
      onHover: (details) {
        if (mounted) {
          final RenderBox box = context.findRenderObject() as RenderBox;
          final size = box.size;
          final offsetX = details.localPosition.dx - (size.width / 2);
          final offsetY = details.localPosition.dy - (size.height / 2);

          setState(() {
            x = (offsetY / (size.height / 2)).clamp(-1.0, 1.0);
            y = -(offsetX / (size.width / 2)).clamp(-1.0, 1.0); 
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(isHovered ? x * (widget.depth / 100) : 0)
          ..rotateY(isHovered ? y * (widget.depth / 100) : 0)
          ..scale(isHovered ? widget.scale : 1.0),
        alignment: FractionalOffset.center,
        child: widget.child,
      ),
    );
  }
}
