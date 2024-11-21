import 'package:flutter/material.dart';
import 'views/home_view.dart'; // Import HomeView

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
      home: HomeView(), // Nastavení výchozí obrazovky
    );
  }
}
