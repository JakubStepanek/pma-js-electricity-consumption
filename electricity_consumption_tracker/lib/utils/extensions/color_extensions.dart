// ignore_for_file: deprecated_member_use

import 'dart:ui';

extension ColorExtension on Color {
  /// Convert the color to a darken color based on the [percent]
  Color darken([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = 1 - percent / 100;
    return Color.fromARGB(
      alpha,
      (red * value).round(),
      (green * value).round(),
      (blue * value).round(),
    );
  }

  Color lighten([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = percent / 100;
    return Color.fromARGB(
      alpha,
      (red + ((255 - red) * value)).round(),
      (green + ((255 - green) * value)).round(),
      (blue + ((255 - blue) * value)).round(),
    );
  }

  Color avg(Color other) {
    final red = (this.r + other.r) ~/ 2;
    final green = (this.g + other.g) ~/ 2;
    final blue = (this.b + other.b) ~/ 2;
    final alpha = (this.a + other.a) ~/ 2;
    return Color.fromARGB(alpha, red, green, blue);
  }
}