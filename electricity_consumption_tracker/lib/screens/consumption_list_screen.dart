import 'package:flutter/material.dart';
import '../database/database.dart';
import '../navigation/app_navigation.dart';

class ConsumptionListScreen extends StatefulWidget {
  final AppDatabase db;
  // konstruktor AppDatabase
  ConsumptionListScreen({required this.db});

  @override
  _ConsumptionListScreenState createState() => _ConsumptionListScreenState();
}

class _ConsumptionListScreenState extends State<ConsumptionListScreen> {
  String? _selectedYear;

  // Mock data for demonstration purposes
  final List<Map<String, dynamic>> data = [
    {
      'date': '2024-11-20',
      'lowTariff': 120.5,
      'highTariff': 80.3,
      'saleTariff': 50.2,
    },
    {
      'date': '2023-10-15',
      'lowTariff': 110.0,
      'highTariff': 90.1,
      'saleTariff': 45.7,
    },
    {
      'date': '2024-09-10',
      'lowTariff': 150.0,
      'highTariff': 100.0,
      'saleTariff': 60.0,
    },
    {
      'date': '2023-12-01',
      'lowTariff': 95.0,
      'highTariff': 85.0,
      'saleTariff': 40.0,
    },
  ];

  List<String> get _availableYears {
    // Extract unique years from data and return as List<String>
    return [
      'Všechny roky',
      ...data
          .map((record) => record['date'].substring(0, 4))
          .toSet()
          .map((year) => year.toString())
          .toList()
        ..sort(),
    ];
  }

  List<Map<String, dynamic>> get _filteredData {
    if (_selectedYear == null || _selectedYear == 'Všechny roky') {
      return data;
    } else {
      return data
          .where((record) => record['date'].startsWith(_selectedYear!))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seznam odečtů'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  'Rok: ',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 16),
                DropdownButton<String>(
                  value: _selectedYear,
                  hint: Text('Vyberte rok'),
                  items: _availableYears
                      .map((year) => DropdownMenuItem<String>(
                            value: year,
                            child: Text(year),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedYear = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredData.length,
              itemBuilder: (context, index) {
                final record = _filteredData[index];
                return Card(
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
                              'Datum: ${record['date']}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text('Nízký tarif: ${record['lowTariff']} kWh'),
                            Text('Vysoký tarif: ${record['highTariff']} kWh'),
                            Text('Prodejní tarif: ${record['saleTariff']} kWh'),
                          ],
                        ),
                        // Icons for actions
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              color: Colors.blue,
                              onPressed: () {
                                // Add edit functionality here
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                // Add delete functionality here
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppNavigation(db: widget.db, currentIndex: 1),
    );
  }
}
