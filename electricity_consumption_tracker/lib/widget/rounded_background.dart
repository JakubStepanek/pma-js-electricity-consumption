import 'package:flutter/material.dart';

class RoundedBackground extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final double backgroundOpacity;

  const RoundedBackground({
    Key? key,
    required this.child,
    this.margin = const EdgeInsets.all(8.0),
    this.padding = const EdgeInsets.all(8.0),
    this.borderRadius = 12.0,
    this.borderColor = Colors.black,
    this.borderWidth = 1.0,
    this.backgroundOpacity = 0.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(backgroundOpacity),
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}
