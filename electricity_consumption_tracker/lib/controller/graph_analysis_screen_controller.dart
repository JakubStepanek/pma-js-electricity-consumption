/// The `GraphAnalysisScreenController` class manages fetching data from a database for graph analysis
/// in a Flutter application.
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:electricity_consumption_tracker/database/database.dart';

class GraphAnalysisScreenController {
  /// The line `final AppDatabase _db;` is declaring a private final instance variable `_db` of type
  /// `AppDatabase` in the `GraphAnalysisScreenController` class. This variable is used to store an
  /// instance of the `AppDatabase` class, which is presumably a database object that the controller
  /// will interact with to fetch data for graph analysis.
  final AppDatabase _db;

  GraphAnalysisScreenController(this._db);

  /// The function `getGraphDataStream` returns a stream of lists of monthly sums for specified columns
  /// and year.
  ///
  /// Args:
  ///   year (int): The `year` parameter is an integer representing the specific year for which you want
  /// to retrieve data for the graph.
  ///   columns (List<String>): A list of strings representing the columns for which you want to
  /// retrieve data.
  ///
  /// Returns:
  ///   The function `getGraphDataStream` returns a stream of lists of lists of nullable doubles. It
  /// combines multiple streams of monthly sums of columns for a given year and maps them into a single
  /// stream of lists of lists of doubles.
  Stream<List<List<double?>>> getGraphDataStream(
      int year, List<String> columns) {
    final List<Stream<List<double?>>> streams = columns
        .map((column) => _db.getMonthlySumOfColumnForYear(column, year))
        .toList();

    return CombineLatestStream.list(streams).map((listOfLists) {
      return listOfLists
          .map(
              (innerList) => (innerList as List<double>).map((e) => e).toList())
          .toList();
    });
  }

  /// This function returns a Future containing a list of unique years from a database.
  ///
  /// Returns:
  ///   A `Future` containing a `List` of `int` values representing unique years is being returned. The
  /// `getUniqueYears()` method is fetching these unique years from a database and wrapping them in a
  /// `Future` for asynchronous handling.
  Future<List<int>> getUniqueYears() {
    return _db.getUniqueYears();
  }
}
