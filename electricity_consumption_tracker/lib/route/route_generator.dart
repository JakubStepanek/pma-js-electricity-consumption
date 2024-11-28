import 'package:electricity_consumption_tracker/screen/add_consumption_screen.dart';
import 'package:electricity_consumption_tracker/screen/consumption_list_screen.dart';
import 'package:electricity_consumption_tracker/screen/edit_consumption_screen.dart';
import 'package:electricity_consumption_tracker/screen/graph_analysis_screen.dart';
import 'package:electricity_consumption_tracker/screen/home_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
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

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Cesta neexistuje'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Omlouvám se, ale cestu, kterou hledáte nelze najít!',
              style: TextStyle(color: Colors.red, fontSize: 18.0)),
        ),
      );
    });
  }
}
