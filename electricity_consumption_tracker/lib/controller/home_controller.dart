import 'package:electricity_consumption_tracker/navigation/app_navigation.dart';

class HomeController {
final int currentYear = DateTime.now().year;

  // Získání aktuální spotřeby za rok
  double getCurrentYearTotalConsumption() {
    return 0;
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
