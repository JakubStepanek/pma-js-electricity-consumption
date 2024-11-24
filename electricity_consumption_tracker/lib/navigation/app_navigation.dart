import 'package:electricity_consumption_tracker/database/database.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/add_consumption_screen.dart';
import '../screens/consumption_list_screen.dart';
import '../screens/graph_analysis_screen.dart';

class AppNavigation extends StatefulWidget {
  final AppDatabase db;
  final int currentIndex;

  AppNavigation({required this.db, this.currentIndex = 0});

  @override
  _AppNavigationState createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex; // Nastavení výchozího indexu
  }

  void _onItemTapped(int index) {
    if (_currentIndex == index) return;

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentScreen;

    // Vyber správnou obrazovku podle aktuálního indexu
    switch (_currentIndex) {
      case 0:
        currentScreen = HomeScreen(db: widget.db);
        break;
      // case 1:
      //   //currentScreen = ConsumptionListScreen(db: widget.db);
      //   break;
      case 2:
        currentScreen = AddConsumptionScreen(db: widget.db);
        break;
      case 3:
        currentScreen = GraphAnalysisScreen(db: widget.db);
        break;
      default:
        currentScreen = HomeScreen(db: widget.db);
    }

    return Scaffold(
      body: currentScreen,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Domů",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Seznam odečtů",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Přidat odečet",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: "Grafy",
          ),
        ],
      ),
    );
  }
}
