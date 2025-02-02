import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:electricity_consumption_tracker/database/database.dart';

class GraphAnalysisScreenController {
  final AppDatabase _db;

  GraphAnalysisScreenController(this._db);

  // získání dat v rocích

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

  Future<List<int>> getUniqueYears() {
    return _db.getUniqueYears();
  }
}
