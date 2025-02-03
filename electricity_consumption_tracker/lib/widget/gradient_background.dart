import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topLeft, // Orange starts at top left
          radius: 1.5, // Adjust to control the spread of the gradient
          colors: [
            Colors.orange, // Orange for the top left circle effect
            Color(0xFF191970), // Midnight blue for the rest of the background
          ],
          stops: [0.2, 1.0], // 0.2 controls how much area is orange
        ),
      ),
      child: child,
    );
  }
}
