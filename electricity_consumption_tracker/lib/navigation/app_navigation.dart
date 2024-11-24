import 'package:flutter/material.dart';

class AppNavigation extends StatefulWidget {
  // final int currentIndex;

  // AppNavigation({this.currentIndex = 0});

  @override
  _AppNavigationState createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  @override
  void initState() {
    super.initState();
    //_currentIndex = widget.currentIndex; // Nastavení výchozího indexu
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 1:
        Navigator.pushNamed(context, '/consumption_list');
        break;
      case 2:
        Navigator.pushNamed(context, '/add_consumption');
        break;
      case 3:
        Navigator.pushNamed(context, '/graph_analysis');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
