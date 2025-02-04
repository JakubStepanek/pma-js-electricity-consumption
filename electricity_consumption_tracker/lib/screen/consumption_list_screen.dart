import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:electricity_consumption_tracker/database/database.dart';

class ConsumptionListScreen extends StatefulWidget {
  const ConsumptionListScreen({Key? key}) : super(key: key);

  @override
  State<ConsumptionListScreen> createState() => _ConsumptionListScreenState();
}

class _ConsumptionListScreenState extends State<ConsumptionListScreen> {
  DateTimeRange? _selectedDateRange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Use a custom back button that pops the route.
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Seznam odečtů'),
        // Use flexibleSpace to paint a gradient behind the AppBar content.
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topLeft, // Orange starts at top left.
              radius: 1.1, // Adjust to control the spread of the gradient.
              colors: [
                Colors.orange, // Top left circle effect.
                Color(0xFF191970), // Midnight blue for the rest of the background.
              ],
              stops: [0.2, 1.0], // Controls how much area is orange.
            ),
          ),
        ),
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          List<Consumption>? consumptions = snapshot.data;
          // Apply date range filter if selected.
          if (_selectedDateRange != null && consumptions != null) {
            consumptions = consumptions.where((consumption) {
              return consumption.date.isAfter(_selectedDateRange!.start) &&
                  consumption.date.isBefore(
                    _selectedDateRange!.end.add(const Duration(days: 1)),
                  );
            }).toList();
          }
          // Sort consumptions by date in ascending order.
          if (consumptions != null && consumptions.isNotEmpty) {
            consumptions.sort((a, b) => a.date.compareTo(b.date));
          }
          if (consumptions != null && consumptions.isNotEmpty) {
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
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${consumption.date.toLocal()}'.split(' ')[0],
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
                                  await _deleteConsumption(context, consumption.id);
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
