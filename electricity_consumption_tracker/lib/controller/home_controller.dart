import 'package:electricity_consumption_tracker/navigation/app_navigation.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';

class HomeController {
  // Získání aktuální spotřeby za rok
  int getCurrentYearConsumption() {
    // Simulovaná data pro aktuální spotřebu
    return 1250; // Prozatím pevně daná hodnota
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
