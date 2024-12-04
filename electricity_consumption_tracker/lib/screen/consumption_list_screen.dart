import 'package:electricity_consumption_tracker/database/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsumptionListScreen extends StatefulWidget {
  const ConsumptionListScreen({Key? key}) : super(key: key);

  @override
  State<ConsumptionListScreen> createState() => _ConsumptionListScreenState();
}

class _ConsumptionListScreenState extends State<ConsumptionListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seznam odečtů'),
      ),
      body: StreamBuilder<List<Consumption>>(
        stream: Provider.of<AppDatabase>(context).getConsumptionStream(),
        builder: (context, snapshot) {
          final List<Consumption>? consumptions = snapshot.data;

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

          if (consumptions != null && consumptions.isNotEmpty) {
            return ListView.builder(
                itemCount: consumptions.length,
                itemBuilder: (context, index) {
                  final consumption = consumptions[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/edit_consumption',
                          arguments: consumption.id);
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Column for text information
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${consumption.date.toString()}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(
                                    'Nízký tarif: ${consumption.consumptionTarifLow.toString()} kWh'),
                                Text(
                                    'Vysoký tarif: ${consumption.consumptionTarifHigh.toString()} kWh'),
                                Text(
                                    'Prodejní tarif: ${consumption.consumptionTarifOut == null ? 0 : consumption.consumptionTarifOut.toString()} kWh'),
                              ],
                            ),
                            // Icons for actions
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  color: Colors.blue,
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/edit_consumption',
                                        arguments: consumption.id);
                                  },
                                ),
                                IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () async {
                                      _deleteConsumption(
                                          context, consumption.id);
                                    }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
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
        title: Text('Smazat odečet'),
        content: Text('Opravdu chcete tento odečet smazat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Zrušit'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Smazat'),
          ),
        ],
      ),
    );

    if (shouldDelete ?? false) {
      await Provider.of<AppDatabase>(context, listen: false)
          .deleteConsumption(consumptionId);
      setState(() {}); // Obnoví seznam odečtů
    }
  }
}
