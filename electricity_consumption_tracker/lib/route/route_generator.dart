import 'package:electricity_consumption_tracker/screens/add_consumption_screen.dart';
import 'package:electricity_consumption_tracker/screens/consumption_list_screen.dart';
import 'package:electricity_consumption_tracker/screens/graph_analysis_screen.dart';
import 'package:electricity_consumption_tracker/screens/home_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/consumption_list':
        return MaterialPageRoute(builder: (_) => ConsumptionListScreen());
      case '/add_consumption':
        return MaterialPageRoute(builder: (_) => AddConsumptionScreen());
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
