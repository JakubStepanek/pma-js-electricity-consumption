import 'package:drift/drift.dart';
import '../database/database.dart';
import '../database/tables/consumption_table.dart';

part 'database_helper.g.dart';

@DriftAccessor(tables: [Consumptions])
class DatabaseHelper extends DatabaseAccessor<AppDatabase> with _$DatabaseHelperMixin {
  DatabaseHelper(AppDatabase db) : super(db);

  Future<List<Consumption>> getAllConsumptions() => select(consumptions).get();

  Future<int> insertConsumption(ConsumptionsCompanion entry) =>
      into(consumptions).insert(entry);

  Future<bool> updateConsumption(Consumption consumption) =>
      update(consumptions).replace(consumption);

  Future<int> deleteConsumption(int id) =>
      (delete(consumptions)..where((t) => t.id.equals(id))).go();
}
