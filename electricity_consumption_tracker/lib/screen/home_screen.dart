import 'package:flutter/material.dart';
import 'package:electricity_consumption_tracker/navigation/app_navigation.dart';
import '../controller/home_controller.dart'; // Import controlleru

class HomeScreen extends StatelessWidget {
  int index = 0;
  final HomeController _controller =
      HomeController(); // Vytvoření instance controlleru

  @override
  Widget build(BuildContext context) {
    final stats =
        _controller.getStatistics(); // Získání statistik z controlleru

    return Scaffold(
      appBar: AppBar(title: const Text('Spotřeba elektřiny')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Spotřeba za aktuální rok
            Text(
              'Spotřeba za aktuální rok: ${_controller.getCurrentYearTotalConsumption()} kWh',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Placeholder pro graf
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Graf spotřeby',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Statistiky
            Text(
              'Statistiky:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Za poslední měsíc:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nízký tarif [kW/h]:',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${stats['lowTarif']}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vysoký tarif [kW/h]:',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${stats['highTarif']}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Prodejní tarif [kW/h]:',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${stats['sellingTarif']}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 32),

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
