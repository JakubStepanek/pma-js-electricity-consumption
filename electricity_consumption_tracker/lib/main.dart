import 'package:flutter/material.dart';
import './database/database.dart';
import 'screens/home_screen.dart'; // Import HomeView

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Initializing database...');
  final database = await AppDatabase();

  print('Database initialized: \$database');
  runApp(ElectricityConsumptionApp(db: database));
}

class ElectricityConsumptionApp extends StatelessWidget {
  final AppDatabase db;
  ElectricityConsumptionApp({required this.db});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Electricity Consumption',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(), // Nastavení výchozí obrazovky
    );
  }
}
