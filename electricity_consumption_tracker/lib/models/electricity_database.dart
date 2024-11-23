import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

part 'electricity_database.g.dart';

@DataClassName('ElectricityConsumptionEntry')
class ElectricityConsumptions extends Table {
  IntColumn get id => integer().autoIncrement()(); // automaticky generované ID
  DateTimeColumn get date => dateTime()();
  RealColumn get consumptionTarifLow => real()();
  RealColumn get consumptionTarifHigh => real()();
  RealColumn get consumptionTarifOut => real().nullable()();
}

@DriftDatabase(tables: [ElectricityConsumptions])
class ElectricityDatabase extends _$ElectricityDatabase {
  ElectricityDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<ElectricityConsumptionEntry>> getAllConsumptions() =>
      select(electricityConsumptions).get();

  Future<int> insertConsumption(ElectricityConsumptionEntry entry) =>
      into(electricityConsumptions).insert(entry);

  Future<int> deleteConsumption(int id) =>
      (delete(electricityConsumptions)..where((entry) => entry.id.equals(id)))
          .go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'electricity.sqlite'));
    return NativeDatabase(file);
  });
}
