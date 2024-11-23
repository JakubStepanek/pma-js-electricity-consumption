import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Import HomeView

void main() {
  runApp(ElectricityConsumptionApp());
}

class ElectricityConsumptionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Electricity Consumption',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(), // Nastavení výchozí obrazovky
    );
  }
}
