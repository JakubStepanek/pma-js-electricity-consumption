import 'package:flutter/material.dart';

/// A widget that displays its [child] inside a container with rounded corners,
/// a border, and a semi-transparent background.
///
/// The [RoundedBackground] widget is useful for emphasizing or visually separating
/// content by wrapping it in a styled container. You can customize the margin,
/// padding, border radius, border color, border width, and background opacity.
class RoundedBackground extends StatelessWidget {
  /// The widget that is displayed inside the rounded background.
  final Widget child;

  /// The outer margin around the container.
  final EdgeInsetsGeometry margin;

  /// The inner padding within the container.
  final EdgeInsetsGeometry padding;

  /// The radius for the container's rounded corners.
  final double borderRadius;

  /// The color of the container's border.
  final Color borderColor;

  /// The width of the container's border.
  final double borderWidth;

  /// The opacity of the container's background color.
  ///
  /// A value of 1.0 means fully opaque and 0.0 means fully transparent.
  final double backgroundOpacity;

  /// Creates a [RoundedBackground] widget.
  ///
  /// The [child] parameter is required and specifies the content to be displayed
  /// inside the container. Optional parameters include [margin], [padding], [borderRadius],
  /// [borderColor], [borderWidth], and [backgroundOpacity], which all have default values.
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

  /// Builds the widget tree for the [RoundedBackground].
  ///
  /// Returns a [Container] that applies the specified [margin], [padding], and [decoration].
  /// The decoration includes a background color with the given [backgroundOpacity],
  /// a border with the specified [borderColor] and [borderWidth], and rounded corners
  /// defined by [borderRadius].
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        // Set the background color with the desired opacity.
        color: Colors.black.withOpacity(backgroundOpacity),
        // Set the border with the specified color and width.
        border: Border.all(color: borderColor, width: borderWidth),
        // Set the border radius for rounded corners.
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}
