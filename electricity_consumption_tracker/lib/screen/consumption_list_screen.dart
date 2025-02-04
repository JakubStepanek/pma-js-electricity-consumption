import 'package:electricity_consumption_tracker/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:electricity_consumption_tracker/database/database.dart';

class ConsumptionListScreen extends StatefulWidget {
  const ConsumptionListScreen({Key? key}) : super(key: key);

  @override
  State<ConsumptionListScreen> createState() => _ConsumptionListScreenState();
}

class _ConsumptionListScreenState extends State<ConsumptionListScreen> {
  DateTimeRange? _selectedDateRange;

  /// This Dart function builds a screen displaying a list of consumptions with options to filter by
  /// date range, edit, and delete each consumption entry.
  ///
  /// Args:
  ///   context (BuildContext): The `context` parameter in Flutter represents the build context of the
  /// widget. It is a reference to the location of a widget within the widget tree. The context provides
  /// access to various properties and methods related to the widget, such as theme, localization, and
  /// navigation.
  ///
  /// Returns:
  ///   A Scaffold widget is being returned, which contains an AppBar with a title 'Seznam odečtů' and
  /// various actions such as IconButton for filtering and clearing date range. The body of the Scaffold
  /// is a StreamBuilder that listens to a stream of Consumption data and displays a list of
  /// consumptions based on the selected date range. Each consumption item in the list is displayed
  /// within a Card widget with
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Seznam odečtů'),
        flexibleSpace: GradientAppBar(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final DateTimeRange? picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                initialDateRange: _selectedDateRange,
              );
              if (picked != null && picked != _selectedDateRange) {
                setState(() {
                  _selectedDateRange = picked;
                });
              }
            },
          ),
          if (_selectedDateRange != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _selectedDateRange = null;
                });
              },
            ),
        ],
      ),
      body: StreamBuilder<List<Consumption>>(
        stream: Provider.of<AppDatabase>(context).getConsumptionsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          List<Consumption>? consumptions = snapshot.data;
          if (_selectedDateRange != null && consumptions != null) {
            consumptions = consumptions.where((consumption) {
              return consumption.date.isAfter(_selectedDateRange!.start) &&
                  consumption.date.isBefore(
                    _selectedDateRange!.end.add(const Duration(days: 1)),
                  );
            }).toList();
          }
          if (consumptions != null && consumptions.isNotEmpty) {
            consumptions.sort((a, b) => a.date.compareTo(b.date));
            return ListView.builder(
              itemCount: consumptions.length,
              itemBuilder: (context, index) {
                final consumption = consumptions![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/edit_consumption',
                      arguments: consumption.id,
                    );
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('d. MMMM yyyy', 'cs')
                                    .format(consumption.date.toLocal()),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                  'Nízký tarif: ${consumption.consumptionTarifLow} kWh'),
                              Text(
                                  'Vysoký tarif: ${consumption.consumptionTarifHigh} kWh'),
                              Text(
                                  'Prodejní tarif: ${consumption.consumptionTarifOut ?? 0} kWh'),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                color: Colors.blue,
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/edit_consumption',
                                    arguments: consumption.id,
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () async {
                                  await _deleteConsumption(
                                      context, consumption.id);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: Text(
              'Zatím nemáte žádné odečty!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }

  /// The function `_deleteConsumption` displays a confirmation dialog to delete a consumption entry and
  /// deletes it if confirmed.
  ///
  /// Args:
  ///   context (BuildContext): The `context` parameter in the `_deleteConsumption` method refers to the
  /// `BuildContext` object. It represents the location of a widget in the widget tree. The `context`
  /// parameter is used to access information about the widget's location in the widget tree, such as
  /// theme data, media queries
  ///   consumptionId (int): The `consumptionId` parameter in the `_deleteConsumption` method is an
  /// integer value that represents the unique identifier of the consumption record that you want to
  /// delete from the database. This parameter is used to identify the specific consumption entry that
  /// the user wants to delete when the deletion action is confirmed in
  Future<void> _deleteConsumption(
      BuildContext context, int consumptionId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Smazat odečet'),
        content: const Text('Opravdu chcete tento odečet smazat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Zrušit'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Smazat'),
          ),
        ],
      ),
    );
    if (shouldDelete ?? false) {
      await Provider.of<AppDatabase>(context, listen: false)
          .deleteConsumption(consumptionId);
      setState(() {});
    }
  }
}
