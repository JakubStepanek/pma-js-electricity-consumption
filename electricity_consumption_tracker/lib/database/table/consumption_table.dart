import 'package:drift/drift.dart';

class Consumptions extends Table {
  IntColumn get id =>
      integer().autoIncrement()(); // Automaticky inkrementované ID
  DateTimeColumn get date => dateTime()(); // Datum
  RealColumn get consumptionTarifLow => real()(); // Spotřeba nízkého tarifu
  RealColumn get consumptionTarifHigh => real()(); // Spotřeba vysokého tarifu
  RealColumn get consumptionTarifOut =>
      real().nullable()(); // Tarif pro prodej elektřiny (solární panely)
}
