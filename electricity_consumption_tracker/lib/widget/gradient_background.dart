import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base radial gradient.
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topLeft, // Orange starts at top left.
              radius: 1.1, // Adjust to control the spread of the gradient.
              colors: [
                Color.fromRGBO(245, 124, 0, 1), // Orange for the top left circle effect.
                Color(0xFF191970), // Midnight blue for the rest of the background.
              ],
              stops: [0.2, 1.0], // 0.2 controls how much area is orange.
            ),
          ),
        ),
        // Overlay linear gradient from bottom to top that creates a light effect.
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                // Using Color.fromRGBO to create a 15% opaque black.
                Color.fromRGBO(0, 0, 0, 0.15),
                Colors.transparent,
              ],
              stops: [0.0, 0.5],
            ),
          ),
        ),
        // Additional overall dark overlay to make the entire background darker.
        Container(
          // Here we use Color.fromRGBO to create a 10% opaque black.
          color: Color.fromRGBO(0, 0, 0, 0.10),
        ),
        // Finally, your child content is rendered on top.
        child,
      ],
    );
  }
}
