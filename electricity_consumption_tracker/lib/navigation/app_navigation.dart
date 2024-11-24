import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/add_consumption_screen.dart';
import '../screens/consumption_list_screen.dart';
import '../screens/graph_analysis_screen.dart';

class AppNavigation extends StatefulWidget {
  final int currentIndex;

  AppNavigation({this.currentIndex = 0});

  @override
  _AppNavigationState createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex; // Nastavení výchozího indexu
  }

  void _onItemTapped(int index) {
    if (_currentIndex == index)
      return; // Aby se zbytečně znovu okno neaktualizovalo

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ConsumptionListScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AddConsumptionScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GraphAnalysisScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
    );
  }
}
