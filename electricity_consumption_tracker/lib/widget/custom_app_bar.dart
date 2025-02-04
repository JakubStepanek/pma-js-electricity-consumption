import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget {
  const GradientAppBar({
    super.key,
  });

  /// The build function returns a Container widget with a radial gradient decoration in Flutter.
  ///
  /// Args:
  ///   context (BuildContext): The `context` parameter in the `build` method of a Flutter widget
  /// represents the location of the widget within the widget tree. It provides access to various
  /// information and services higher up in the widget tree, such as theme data, media queries, and
  /// navigation.
  ///
  /// Returns:
  ///   A Container widget with a radial gradient decoration is being returned. The gradient has colors
  /// ranging from orange to a dark blue color (Color(0xFF191970)) with stops at 0.2 and 1.0.
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 1.1,
          colors: [
            Colors.orange,
            Color(0xFF191970),
          ],
          stops: [0.2, 1.0],
        ),
      ),
    );
  }
}
