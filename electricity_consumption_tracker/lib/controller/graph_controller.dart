import 'package:electricity_consumption_tracker/database/database.dart';

class GraphController {
  final int currentYear = DateTime.now().year;
  final AppDatabase _db;

  GraphController(this._db);

  /// Získání součtu spotřeby pro vysoký tarif za zvolený rok
  Stream<double?> getHighTarifSumOfYear(int year) {
    return _db.getHighTarifSumOfYear(year);
  }

  /// Získání dat spotřeby pro daný tarif a rok
  Future<List<double?>> getMonthlyConsumptionForYear(
      String tariffColumn, int year) async {
    List<double?> monthlyData = [];

    for (int month = 1; month <= 12; month++) {
      final result = await _db.getSumOfColumnForMonthAndYear(
          tariffColumn, month, year).first;
      monthlyData.add(result ?? 0.0); // Nahrazení null hodnot nulou
    }

    return monthlyData;
  }

  /// Získání unikátních roků z databáze
  Future<List<int>> getUniqueYears() {
    return _db.getUniqueYears();
  }
}
