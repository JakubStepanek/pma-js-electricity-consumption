import 'package:electricity_consumption_tracker/resources/app_colors.dart';
import 'package:electricity_consumption_tracker/screen/add_consumption_screen.dart';
import 'package:electricity_consumption_tracker/screen/consumption_list_screen.dart';
import 'package:electricity_consumption_tracker/screen/edit_consumption_screen.dart';
import 'package:electricity_consumption_tracker/screen/graph_analysis_screen.dart';
import 'package:electricity_consumption_tracker/screen/home_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  /// This Dart function generates different routes based on the provided settings in a Flutter
  /// application.
  ///
  /// Args:
  ///   settings (RouteSettings): The `generateRoute` function you provided is responsible for
  /// generating routes based on the settings passed to it. The `settings` parameter of type
  /// `RouteSettings` contains information about the route that needs to be generated, such as the route
  /// name and arguments.
  ///
  /// Returns:
  ///   The `generateRoute` method returns a `Route<dynamic>` based on the `settings.name` provided. It
  /// checks the `settings.name` and returns a specific `MaterialPageRoute` for each route such as
  /// `HomeScreen`, `ConsumptionListScreen`, `AddConsumptionScreen`, `EditConsumptionScreen`,
  /// `GraphAnalysisScreen`. If the `settings.name` does not match any of the

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/consumption_list':
        return MaterialPageRoute(builder: (_) => ConsumptionListScreen());
      case '/add_consumption':
        return MaterialPageRoute(builder: (_) => AddConsumptionScreen());
      case '/edit_consumption':
        if (args is int) {
          return MaterialPageRoute(
              builder: (_) => EditConsumptionScreen(
                    id: args,
                  ));
        }
        return _errorRoute();
      case '/graph_analysis':
        return MaterialPageRoute(builder: (_) => GraphAnalysisScreen());
      default:
        return _errorRoute();
    }
  }

  /// The `_errorRoute` function returns a MaterialPageRoute displaying a message for a non-existent
  /// route.
  ///
  /// Returns:
  ///   A MaterialPageRoute with a Scaffold widget containing an AppBar with a title 'Cesta neexistuje'
  /// and a body with a centered Text widget displaying 'Omlouvám se, ale cestu, kterou hledáte nelze
  /// najít!' in red color and font size 18.0.

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Cesta neexistuje'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Omlouvám se, ale cestu, kterou hledáte nelze najít!',
              style: TextStyle(color: AppColors.contentColorRed, fontSize: 18.0)),
        ),
      );
    });
  }
}
