import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({Key? key, required this.child}) : super(key: key);

  /// The build function returns a Stack widget with multiple Container widgets having different gradient
  /// and color decorations.
  ///
  /// Args:
  ///   context (BuildContext): The `context` parameter in the `build` method of a Flutter widget
  /// represents the location of the widget within the widget tree. It provides access to various
  /// properties and methods related to the widget's location and configuration in the app.
  ///
  /// Returns:
  ///   A Stack widget is being returned with multiple children. The children are as follows:
  /// 1. A Container with a radial gradient decoration.
  /// 2. Another Container with a linear gradient decoration.
  /// 3. A Container with a solid color.
  /// 4. The 'child' widget that is passed as a parameter to the build method.
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 1.1,
              colors: [
                Color.fromRGBO(245, 124, 0, 1),
                Color(0xFF191970),
              ],
              stops: [0.2, 1.0],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromRGBO(0, 0, 0, 0.15),
                Colors.transparent,
              ],
              stops: [0.0, 0.5],
            ),
          ),
        ),
        Container(
          color: Color.fromRGBO(0, 0, 0, 0.10),
        ),
        child,
      ],
    );
  }
}
