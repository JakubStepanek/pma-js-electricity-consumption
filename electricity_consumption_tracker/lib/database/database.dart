import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'table/consumption_table.dart';

part 'database.g.dart';

// Fake repository
// Funkce pro vytvoření připojení k databázi
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'consumptions.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

// @DriftDatabase(tables: [Consumptions], daos: [DatabaseHelper])
@DriftDatabase(tables: [Consumptions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Consumption>> getConsumptions() async {
    return await select(consumptions).get();
  }

  Stream<List<Consumption>> getConsumptionsStream() {
    return select(consumptions).watch();
  }

  Future<Consumption> getConsumption(int id) async {
    return await (select(consumptions)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  Future<bool> updateConsumption(ConsumptionsCompanion entity) async {
    return await update(consumptions).replace(entity);
  }

  Future<int> insertConsumption(ConsumptionsCompanion entity) async {
    return await into(consumptions).insert(entity);
  }

  Future<int> deleteConsumption(int id) async {
    return await (delete(consumptions)..where((tbl) => tbl.id.equals(id))).go();
  }

  // funkce pro získání spotřeby vysokého tarifu v roce
  Stream<double?> getHighTarifSumOfYear(int year) {
    return (selectOnly(consumptions)
          ..addColumns([consumptions.consumptionTarifHigh.sum()])
          ..where(consumptions.date.year.equals(year)))
        .watchSingleOrNull()
        .map((row) => row?.read(consumptions.consumptionTarifHigh.sum()));
  }

  Stream<double?> getHighTarifHighestValueOfYearStream(int year) {
    return (selectOnly(consumptions)
          ..addColumns([consumptions.consumptionTarifHigh])
          ..where(consumptions.date.year.equals(year))
          ..orderBy([
            OrderingTerm(
                expression: consumptions.consumptionTarifHigh,
                mode: OrderingMode.desc)
          ])
          ..limit(1))
        .map((row) => row.read(consumptions.consumptionTarifHigh))
        .watchSingleOrNull();
  }

  // funkce pro získání nejvyšší hodnoty pro vysoký tarif v roce
  Future<double?> getHighTarifHighestValueOfYear(int year) async {
    return await (selectOnly(consumptions)
          ..addColumns([consumptions.consumptionTarifHigh])
          ..where(consumptions.date.year.equals(year))
          ..orderBy([
            OrderingTerm(
                expression: consumptions.consumptionTarifHigh,
                mode: OrderingMode.desc)
          ])
          ..limit(1))
        .map((row) => row.read(consumptions.consumptionTarifHigh))
        .getSingleOrNull();
  }

  Future<List<int>> getUniqueYears() async {
    final query = selectOnly(consumptions, distinct: true)
      ..addColumns([consumptions.date.year])
      ..orderBy([OrderingTerm(expression: consumptions.date.year)]);

    final result =
        await query.map((row) => row.read(consumptions.date.year)).get();
    return result.whereType<int>().toList(); // Odstranění null hodnot
  }

  Stream<double?> getSumOfColumnForMonthAndYear(
      String columnName, int month, int year) {
    final Map<String, GeneratedColumn<double>> columnMap = {
      'consumptionTarifHigh': consumptions.consumptionTarifHigh,
      'consumptionTarifLow': consumptions.consumptionTarifLow,
      'consumptionTarifOut': consumptions.consumptionTarifOut,
    };

    final column = columnMap[columnName];
    if (column == null) {
      throw ArgumentError('Sloupec "$columnName" nebyl nalezen.');
    }

    return (selectOnly(consumptions)
          ..addColumns([column.sum()])
          ..where(consumptions.date.month.equals(month))
          ..where(consumptions.date.year.equals(year)))
        .watchSingleOrNull()
        .map((row) => row?.read(column.sum()));
  }

  Stream<List<double>> getMonthlySumOfColumnForYear(
      String columnName, int year) {
    return (select(consumptions)
          ..where((tbl) =>
              tbl.date.year.equals(year))) // Filtrujeme na konkrétní rok
        .watch()
        .map((rows) {
      // Vytvoříme seznam 12 hodnot (pro každý měsíc)
      final monthlySums = List<double>.filled(12, 0.0);

      for (final row in rows) {
        final month = row.date.month; // Získáme měsíc z řádku
        double? value;

        // Dynamicky načítáme hodnoty podle názvu sloupce
        switch (columnName) {
          case 'consumptionTarifHigh':
            value = row.consumptionTarifHigh;
            break;
          case 'consumptionTarifLow':
            value = row.consumptionTarifLow;
            break;
          case 'consumptionTarifOut':
            value = row.consumptionTarifOut;
            break;
          default:
            throw ArgumentError('Sloupec "$columnName" nebyl nalezen.');
        }

        if (month != null && value != null) {
          monthlySums[month - 1] += value; // Přidáme hodnotu pro daný měsíc
        }
      }

      return monthlySums;
    });
  }
}
