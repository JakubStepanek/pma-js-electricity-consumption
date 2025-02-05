import 'package:electricity_consumption_tracker/resources/app_colors.dart';
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

  /// The function `_onItemTapped` navigates to different screens based on the index provided.
  ///
  /// Args:
  ///   index (int): The `index` parameter in the `_onItemTapped` function represents the index of the
  /// item that was tapped in a list or menu. The function uses a `switch` statement to determine which
  /// action to take based on the value of the index. In this case, different routes are pushed to
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

  /// This function builds a BottomNavigationBar widget with multiple items and custom icons and labels.
  ///
  /// Args:
  ///   context (BuildContext): The `context` parameter in the `build` method of a Flutter widget
  /// represents the location of the widget within the widget tree. It provides access to various
  /// properties and methods related to the widget's position and configuration in the UI hierarchy.
  ///
  /// Returns:
  ///   A BottomNavigationBar widget with four BottomNavigationBarItem children is being returned. The
  /// BottomNavigationBar widget has properties like selectedItemColor, unselectedItemColor, onTap, and
  /// type set, and each BottomNavigationBarItem has an icon, activeIcon, and label specified.
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: AppColors.bottomNavigationBarItemSelected,
      unselectedItemColor: AppColors.bottomNavigationBarItemUnselected,
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
