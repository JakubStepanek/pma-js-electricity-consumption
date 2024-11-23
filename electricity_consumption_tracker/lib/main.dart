import 'package:electricity_consumption_tracker/database/database.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Import HomeView

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDb();
// NEZAPOMEŃ NA Companion, voe! -> aby fungovalo autoincrement
  await database
      .into(database.consumptions)
      .insert(ConsumptionsCompanion.insert(
        date: DateTime.now(),
        consumptionTarifLow: 1000,
        consumptionTarifHigh: 120,
      ));

  List<Consumption> allItems =
      await database.select(database.consumptions).get();
  print('items in database: $allItems');
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
