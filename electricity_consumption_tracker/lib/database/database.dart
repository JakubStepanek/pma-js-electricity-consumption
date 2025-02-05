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
/// The `@DriftDatabase(tables: [Consumptions])` annotation is used in Dart with the Drift library to
/// define a database class. In this case, it specifies that the `AppDatabase` class is a Drift database
/// and indicates that it will have a table named `Consumptions`. This annotation helps Drift generate
/// the necessary code for database operations based on the specified tables.
@DriftDatabase(tables: [Consumptions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// The function `getConsumptions` retrieves a list of consumption objects asynchronously.
  ///
  /// Returns:
  ///   A Future object that will eventually resolve to a List of Consumption objects.
  Future<List<Consumption>> getConsumptions() async {
    return await select(consumptions).get();
  }

  /// The function `getConsumptionsStream` returns a stream of lists of `Consumption` objects by
  /// watching the `consumptions` table.
  ///
  /// Returns:
  ///   A stream of lists of Consumption objects is being returned.
  Stream<List<Consumption>> getConsumptionsStream() {
    return select(consumptions).watch();
  }

  /// This function retrieves a single consumption record based on the provided ID asynchronously.
  ///
  /// Args:
  ///   id (int): The `id` parameter is an integer value used to identify a specific consumption record
  /// that you want to retrieve from the database.
  ///
  /// Returns:
  ///   A Future object containing a Consumption instance is being returned. The Consumption instance
  /// represents the consumption data corresponding to the provided ID.
  Future<Consumption> getConsumption(int id) async {
    return await (select(consumptions)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  /// The function `updateConsumption` updates a consumption entity in a database table asynchronously.
  ///
  /// Args:
  ///   entity (ConsumptionsCompanion): The `entity` parameter in the `updateConsumption` function is of
  /// type `ConsumptionsCompanion`. It is used to update a consumption entity in the database.
  ///
  /// Returns:
  ///   The `updateConsumption` function is returning a `Future<bool>`.
  Future<bool> updateConsumption(ConsumptionsCompanion entity) async {
    return await update(consumptions).replace(entity);
  }

  /// The function `insertConsumption` inserts a `ConsumptionsCompanion` entity into a database table
  /// named `consumptions`.
  ///
  /// Args:
  ///   entity (ConsumptionsCompanion): The `entity` parameter in the `insertConsumption` function is of
  /// type `ConsumptionsCompanion`. It is used to represent the data that will be inserted into the
  /// `consumptions` table.
  ///
  /// Returns:
  ///   The `insertConsumption` method is returning a `Future<int>`. This means that it is returning a
  /// future that will eventually resolve to an integer value.
  Future<int> insertConsumption(ConsumptionsCompanion entity) async {
    return await into(consumptions).insert(entity);
  }

  /// The function `deleteConsumption` deletes a consumption record with a specified ID from a database
  /// table.
  ///
  /// Args:
  ///   id (int): The `id` parameter in the `deleteConsumption` function represents the unique
  /// identifier of the consumption record that you want to delete from the database.
  ///
  /// Returns:
  ///   The `deleteConsumption` function is returning a `Future<int>`. This future will eventually
  /// resolve to an integer value, which could represent the number of rows deleted from the database
  /// when the consumption record with the specified `id` is deleted.
  Future<int> deleteConsumption(int id) async {
    return await (delete(consumptions)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// The function `getHighTarifSumOfYear` retrieves the sum of high tariff consumptions for a specific
  /// year from a database table and returns it as a stream of nullable double values.
  ///
  /// Args:
  ///   year (int): The `year` parameter is used to filter the data based on the year of consumption.
  /// The function `getHighTarifSumOfYear` retrieves the sum of consumption with a high tariff for a
  /// specific year.
  ///
  /// Returns:
  ///   A stream of nullable double values representing the sum of high tariff consumption for a
  /// specific year.
  Stream<double?> getHighTarifSumOfYear(int year) {
    return (selectOnly(consumptions)
          ..addColumns([consumptions.consumptionTarifHigh.sum()])
          ..where(consumptions.date.year.equals(year)))
        .watchSingleOrNull()
        .map((row) => row?.read(consumptions.consumptionTarifHigh.sum()));
  }

  /// This Dart function returns a stream of the highest value of consumptionTarifHigh for a specific
  /// year from a database table.
  ///
  /// Args:
  ///   year (int): The `year` parameter is used to filter the data based on the year of consumption
  /// date. The function retrieves a stream of nullable double values representing the highest tariff
  /// value for a specific year.
  ///
  /// Returns:
  ///   A stream of nullable double values representing the highest consumption value for the high
  /// tariff in the specified year.
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

  /// This Dart function retrieves the highest value of high tariff consumption for a specific year from
  /// a database table.
  ///
  /// Args:
  ///   year (int): The `year` parameter is used to specify the year for which you want to retrieve the
  /// highest value of the consumptionTarifHigh from the consumptions table. The function
  /// `getHighTarifHighestValueOfYear` is an asynchronous function that queries the database to find the
  /// highest value of consumptionTarif
  ///
  /// Returns:
  ///   The function `getHighTarifHighestValueOfYear` returns a `Future` that resolves to a nullable
  /// `double`. It queries the `consumptions` table to retrieve the highest value of the
  /// `consumptionTarifHigh` column for a specific year. The result is obtained asynchronously and the
  /// highest value is returned as a nullable `double`.
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

  /// The function `getUniqueYears` retrieves a list of unique years from a database table of
  /// consumptions.
  ///
  /// Returns:
  ///   The `getUniqueYears` function returns a list of unique years as integers. The function queries a
  /// database table named `consumptions` to retrieve distinct years from the `date` column, orders them
  /// in ascending order, and then returns a list of these unique years as integers. Any null values are
  /// filtered out before returning the final list.
  Future<List<int>> getUniqueYears() async {
    final query = selectOnly(consumptions, distinct: true)
      ..addColumns([consumptions.date.year])
      ..orderBy([OrderingTerm(expression: consumptions.date.year)]);

    final result =
        await query.map((row) => row.read(consumptions.date.year)).get();
    return result.whereType<int>().toList(); // Odstranění null hodnot
  }

  /// This Dart function retrieves the sum of a specified column for a given month and year from a
  /// database table.
  ///
  /// Args:
  ///   columnName (String): The `columnName` parameter is used to specify the name of the column for
  /// which you want to calculate the sum. In the provided code snippet, the possible values for
  /// `columnName` are 'consumptionTarifHigh', 'consumptionTarifLow', and 'consumptionTarifOut'.
  ///   month (int): The `month` parameter in the `getSumOfColumnForMonthAndYear` function represents
  /// the month for which you want to calculate the sum of a specific column in the database table. It
  /// is an integer value representing the month (1 for January, 2 for February, and so on up
  ///   year (int): The `year` parameter in the `getSumOfColumnForMonthAndYear` function represents the
  /// year for which you want to calculate the sum of a specific column in the database table. This
  /// function retrieves the sum of the specified column for a given month and year from the database
  /// table.
  ///
  /// Returns:
  ///   A `Stream<double?>` is being returned.
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

  /// The function `getMonthlySumOfColumnForYear` retrieves the monthly sum of a specified column for a
  /// given year from a database table of consumptions.
  ///
  /// Args:
  ///   columnName (String): The `columnName` parameter in the `getMonthlySumOfColumnForYear` function
  /// represents the name of the column in the database table from which you want to calculate the
  /// monthly sum for a specific year. The function dynamically retrieves the values from the specified
  /// column for each row and accumulates the monthly sums
  ///   year (int): The `year` parameter in the `getMonthlySumOfColumnForYear` function is used to
  /// filter the data based on a specific year. The function retrieves monthly sums of a specified
  /// column for the given year from a data source (presumably a database table named `consumptions`).
  /// It calculates the
  ///
  /// Returns:
  ///   A stream of lists of double values representing the monthly sum of a specified column for a
  /// given year.
  Stream<List<double>> getMonthlySumOfColumnForYear(
      String columnName, int year) {
    return (select(consumptions)..where((tbl) => tbl.date.year.equals(year)))
        .watch()
        .map((rows) {
      final monthlySums = List<double>.filled(12, 0.0);

      for (final row in rows) {
        final month = row.date.month;
        double? value;
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

        if (value != null) {
          monthlySums[month - 1] += value;
        }
      }

      return monthlySums;
    });
  }
}
