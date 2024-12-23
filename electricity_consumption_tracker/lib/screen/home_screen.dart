import 'package:electricity_consumption_tracker/database/database.dart';
import 'package:electricity_consumption_tracker/widget/yearly_consumption_chart.dart';
import 'package:flutter/material.dart';
import 'package:electricity_consumption_tracker/navigation/app_navigation.dart';
import 'package:provider/provider.dart';
import '../controller/home_controller.dart'; // Import controlleru

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  // late GraphController _graphController;
  late HomeController _controller;

  @override
  void initState() {
    // To se volá jenom jednou při vytvoření
    super.initState();
    final db = Provider.of<AppDatabase>(context, listen: false);
    _controller = HomeController(db);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Spotřeba elektřiny')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Graph
            YearlyConsumptionChart(
              controller: _controller,
              year: DateTime.now().year,
            ),

            SizedBox(height: 16),

            // Statistiky
            Text(
              'Součet za poslední měsíc:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Nízký tarif [kW/h]: ',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.normal))
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          StreamBuilder<double?>(
                              stream: _controller.getLastMonthLowTarif(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text("Chyba");
                                }

                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }

                                return Text(
                                  '${snapshot.data} kWh',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                );
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Vysoký tarif [kW/h]:',
                              style: textTheme.bodyLarge),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          StreamBuilder<double?>(
                              stream: _controller.getLastMonthHighTarif(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text("Chyba");
                                }

                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }

                                return Text(
                                  '${snapshot.data} kWh',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                );
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Prodejní tarif [kW/h]:',
                              style: textTheme.bodyLarge),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          StreamBuilder<double?>(
                              stream: _controller.getLastMonthOutTarif(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text("Chyba");
                                }

                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }

                                return Text(
                                  '${snapshot.data} kWh',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                );
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Tlačítko pro přidání záznamu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/add_consumption');
                },
                icon: Icon(Icons.add),
                label: Text('Přidat odečet'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppNavigation(),
    );
  }
}
