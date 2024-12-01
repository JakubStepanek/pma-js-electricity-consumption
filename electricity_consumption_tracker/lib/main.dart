import 'package:electricity_consumption_tracker/route/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import './database/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('Database initialized: \$database');
  runApp(
    Provider(
      create: (context) => AppDatabase(),
      child: ElectricityConsumptionApp(),
      dispose: (context, AppDatabase db) => db.close(),
    ),
  );
}

class ElectricityConsumptionApp extends StatelessWidget {
  ElectricityConsumptionApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Electricity Consumption',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}


//TODO: načtení dat ze souboru... data musí mít strukturu DATUM|VYSOKÝ|NÍZKÝ|PRODEJ?
