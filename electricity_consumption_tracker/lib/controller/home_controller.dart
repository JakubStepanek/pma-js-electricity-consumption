import 'package:electricity_consumption_tracker/database/database.dart';
import 'package:electricity_consumption_tracker/navigation/app_navigation.dart';

class HomeController {
  final int currentYear = DateTime.now().year;
  final int currentMonth = DateTime.now().month;
  final AppDatabase _db;

  HomeController(this._db);

  // Získání aktuální spotřeby za rok
  Stream<double?> getCurrentYearTotalConsumption() {
    return _db.getHighTarifSumOfYear(currentYear);
  }

  Stream<double?> getLastMonthLowTarif() {
    return _db.getSumOfColumnForMonthAndYear(
        'consumptionTarifLow', currentMonth, currentYear);
  }

  Stream<double?> getLastMonthHighTarif() {
    return _db.getSumOfColumnForMonthAndYear(
        'consumptionTarifHigh', currentMonth, currentYear);
  }

  Stream<double?> getLastMonthOutTarif() {
    return _db.getSumOfColumnForMonthAndYear(
        'consumptionTarifOut', currentMonth, currentYear);
  }

  void addConsumptionRecord() {
    AppNavigation();
  }

  /// Získání součtu spotřeby pro vysoký tarif za zvolený rok
  Stream<double?> getHighTarifSumOfYear(int year) {
    return _db.getHighTarifSumOfYear(year);
  }

  /// Získání dat spotřeby pro daný tarif a rok
  Future<List<double?>> getMonthlyConsumptionForYear(
      String tariffColumn, int year) async {
    List<double?> monthlyData = [];

    for (int month = 1; month <= 12; month++) {
      final result = await _db
          .getSumOfColumnForMonthAndYear(tariffColumn, month, year)
          .first;
      monthlyData.add(result ?? 0.0); // Nahrazení null hodnot nulou
    }

    return monthlyData;
  }

  /// Získání unikátních roků z databáze
  Future<List<int>> getUniqueYears() {
    return _db.getUniqueYears();
  }
}
