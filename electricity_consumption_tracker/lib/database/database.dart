import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'table/consumption_table.dart';
import 'database_helper.dart';

part 'database.g.dart';

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

  Stream<List<Consumption>> getConsumptionStream() {
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
}
