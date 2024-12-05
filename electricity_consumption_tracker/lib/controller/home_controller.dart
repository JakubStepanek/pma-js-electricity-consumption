import 'package:electricity_consumption_tracker/database/database.dart';
import 'package:electricity_consumption_tracker/navigation/app_navigation.dart';

class HomeController {
  final int currentYear = DateTime.now().year;
  final AppDatabase _db;

  HomeController(this._db);

  // Získání aktuální spotřeby za rok
  Stream<double?> getCurrentYearTotalConsumption() {
    return _db.getHighTarifHighestValueOfYearStream(currentYear);
  }

  // Statistiky
  Map<String, dynamic> getStatistics() {
    // Simulovaná data statistik
    return {
      'averageMonthly': 104.2,
      'highest': 150,
      'lowest': 80,
      'daysCount': 365,
    };
  }

  void addConsumptionRecord() {
    AppNavigation();
  }
}
