import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Import tabulek
import 'tables/consumption_table.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [Consumptions],
)
class AppDb extends _$AppDb {
  // Konstruktor databáze
  AppDb() : super(_openConnection());

  // Verze databázového schématu
  @override
  int get schemaVersion => 1;

  // Příklad metody: Načtení všech záznamů ze spotřeby
  Future<List<Consumption>> getAllConsumptions() => select(consumptions).get();

  // Vložení nové spotřeby
  Future<int> insertConsumption(ConsumptionsCompanion entry) =>
      into(consumptions).insert(entry);

  // Smazání záznamu podle ID
  Future<int> deleteConsumption(int id) =>
      (delete(consumptions)..where((tbl) => tbl.id.equals(id))).go();
}

// Funkce pro vytvoření připojení k databázi
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
