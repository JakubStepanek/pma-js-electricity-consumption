import 'package:flutter/material.dart';
import '../controller/home_controller.dart'; // Import controlleru

class GraphAnalysisScreen extends StatelessWidget {
  final HomeController _controller =
      HomeController(null!); // Vytvoření instance controlleru

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Spotřeba elektřiny')),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),

            // Tlačítko pro přidání záznamu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _controller
                      .addConsumptionRecord(); // Volání controlleru při stisku tlačítka
                },
                icon: Icon(Icons.add),
                label: Text('Přidat záznam'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
