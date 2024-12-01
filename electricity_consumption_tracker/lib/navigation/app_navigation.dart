import 'package:flutter/material.dart';

class AppNavigation extends StatefulWidget {
  @override
  _AppNavigationState createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {

  @override
  void initState() {
    super.initState();
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
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          activeIcon: Icon(Icons.home_outlined),
          label: "Domů",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          activeIcon: Icon(Icons.list_outlined),
          label: "Seznam odečtů",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          activeIcon: Icon(Icons.add_outlined),
          label: "Přidat odečet",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          activeIcon: Icon(Icons.show_chart_outlined),
          label: "Grafy",
        ),
      ],
    );
  }
}
