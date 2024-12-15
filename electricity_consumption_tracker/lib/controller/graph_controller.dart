import 'package:electricity_consumption_tracker/database/database.dart';
import 'package:electricity_consumption_tracker/navigation/app_navigation.dart';

class GraphController {
  final int currentYear = DateTime.now().year;
  final int currentMonth = DateTime.now().month - 1;
  final AppDatabase _db;

  GraphController(this._db);


  Future<List<int>> getUniqueYears(){
    return _db.getUniqueYears();
  }

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
}
