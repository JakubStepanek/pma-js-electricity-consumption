import 'package:electricity_consumption_tracker/database/database.dart';
import 'package:electricity_consumption_tracker/navigation/app_navigation.dart';
import 'package:quiver/time.dart';

/// This class is likely a controller class for managing the home view in a Dart application.
class HomeController {
  final int currentYear = DateTime.now().year;
  final int currentMonth = DateTime.now().month;

  final AppDatabase _db;

  HomeController(this._db);

  /// The function getCurrentYearTotalConsumption returns a stream of double values representing the
  /// total consumption for the current year.
  ///
  /// Returns:
  ///   A stream of nullable double values representing the total consumption for the current year.
  Stream<double?> getCurrentYearTotalConsumption() {
    return _db.getHighTarifSumOfYear(currentYear);
  }

  /// This Dart function returns a stream of the sum of a specified column for the previous month and
  /// current year.
  ///
  /// Args:
  ///   columnName (String): The `columnName` parameter is the name of the column in the database for
  /// which you want to retrieve the sum of values for the last month.
  ///
  /// Returns:
  ///   A stream of nullable double values representing the sum of the specified column for the previous
  /// month and year.
  Stream<double?> getLastMonthTarif(String columnName) {
    return _db.getSumOfColumnForMonthAndYear(
        columnName, currentMonth - 1, currentYear);
  }

  /// This Dart function calculates the average value of a specified column for the last month based on
  /// the sum of values and the number of days in that month.
  ///
  /// Args:
  ///   columnName (String): The `columnName` parameter represents the name of the column in the
  /// database for which you want to calculate the average value for the last month. This method
  /// retrieves the sum of values in that column for the current month and year, then calculates the
  /// average value per day for the last month based on the number
  ///
  /// Returns:
  ///   A stream of nullable double values representing the average value of the specified column for
  /// the current month in the current year.
  Stream<double?> getAverageLastMonthTarif(String columnName) {
    int daysInMonthValue = daysInMonth(currentYear, currentMonth);
    return _db
        .getSumOfColumnForMonthAndYear(columnName, currentMonth, currentYear)
        .map((value) {
      if (value == null) {
        return null;
      } else {
        double average = value / daysInMonthValue;
        return double.parse(average.toStringAsFixed(2));
      }
    });
  }

  /// The function `addConsumptionRecord` calls the `AppNavigation` function.
  void addConsumptionRecord() {
    AppNavigation();
  }

  /// This function returns a stream of high tariff sum for a specific year from a database.
  ///
  /// Args:
  ///   year (int): The `year` parameter is an integer value representing the year for which you want to
  /// retrieve the high tariff sum.
  ///
  /// Returns:
  ///   A stream of nullable double values representing the sum of high tariff values for a specific
  /// year from the database.
  Stream<double?> getHighTarifSumOfYear(int year) {
    return _db.getHighTarifSumOfYear(year);
  }

  /// The function `getMonthlyConsumptionForYear` retrieves monthly consumption data for a specific year
  /// from a database using a given tariff column.
  ///
  /// Args:
  ///   tariffColumn (String): The `tariffColumn` parameter in the `getMonthlyConsumptionForYear`
  /// function represents the column name in the database table where the consumption data is stored. It
  /// is used to retrieve the sum of consumption values for each month and year based on the specified
  /// column.
  ///   year (int): The `year` parameter in the `getMonthlyConsumptionForYear` function represents the
  /// specific year for which you want to retrieve monthly consumption data. This function calculates
  /// and returns the monthly consumption values for each month of the given year based on the provided
  /// `tariffColumn`.
  ///
  /// Returns:
  ///   A `Future<List<double?>>` is being returned. This function retrieves monthly consumption data
  /// for a specific year based on the provided tariff column and year. The data is fetched
  /// asynchronously, and the function returns a list of nullable double values representing the monthly
  /// consumption for each month of the year.
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

  /// The function `getUniqueYears` returns a Future containing a list of unique years fetched from a
  /// database.
  ///
  /// Returns:
  ///   A `Future` object containing a list of integers representing unique years is being returned. The
  /// `getUniqueYears()` method is called on the `_db` object to retrieve these unique years.
  Future<List<int>> getUniqueYears() {
    return _db.getUniqueYears();
  }

  /// This function returns a stream of monthly sums for a specified column and year from a database.
  ///
  /// Args:
  ///   columnName (String): The `columnName` parameter is a string that represents the name of the
  /// column for which you want to calculate the monthly sum.
  ///   year (int): The `year` parameter is an integer value representing the year for which you want to
  /// retrieve the monthly sum of a specific column from the database.
  ///
  /// Returns:
  ///   A stream of lists of double values representing the monthly sum of a specific column for a given
  /// year is being returned.
  Stream<List<double>> getMonthlySumOfColumnForYear(
      String columnName, int year) {
    return _db.getMonthlySumOfColumnForYear(columnName, year);
  }
}
