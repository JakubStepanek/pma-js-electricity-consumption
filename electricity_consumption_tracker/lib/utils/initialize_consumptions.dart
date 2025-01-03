import 'dart:math';
import 'package:drift/drift.dart';
import '/database/database.dart'; // Replace with your Drift database import

Future<void> initializeConsumptions(AppDatabase db) async {
  final random = Random();
  final now = DateTime.now();
  final oneMonthAgo = now.subtract(const Duration(days: 30));

  // Generate at least 30 records
  await db.batch((batch) {
    for (int i = 0; i < 10; i++) {
      // Generate a random date within the last month
      final randomDate = oneMonthAgo.add(
        Duration(days: random.nextInt(30)),
      );

      // Generate random values for consumption and round to 2 decimal places
      final consumptionLow =
          double.parse((random.nextDouble() * 100).toStringAsFixed(2));
      final consumptionHigh =
          double.parse((random.nextDouble() * 150).toStringAsFixed(2));
      final consumptionOut = random.nextBool()
          ? double.parse((random.nextDouble() * 50).toStringAsFixed(2))
          : null; // 50% chance of having a value

      // Add to batch insert
      batch.insert(
        db.consumptions,
        ConsumptionsCompanion(
          date: Value(randomDate),
          consumptionTarifLow: Value(consumptionLow),
          consumptionTarifHigh: Value(consumptionHigh),
          consumptionTarifOut: Value(consumptionOut),
        ),
      );
    }
  });

  print('Initialized table with 30 records over the last month.');
}
