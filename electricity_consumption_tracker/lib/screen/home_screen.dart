import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:electricity_consumption_tracker/database/database.dart';
import 'package:electricity_consumption_tracker/widget/yearly_consumption_chart.dart';
import 'package:electricity_consumption_tracker/navigation/app_navigation.dart';
import '../controller/home_controller.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeController _controller;

  // Mapping of user-friendly option names to database column identifiers
  final Map<String, String> optionToColumnMap = {
    'Nízký tarif': 'consumptionTarifLow',
    'Vysoký tarif': 'consumptionTarifHigh',
    'Prodejní tarif': 'consumptionTarifOut',
  };

  // List of options for the picker
  late final List<String> options;
  String _selectedOption = 'Nízký tarif';

  @override
  void initState() {
    super.initState();
    final db = Provider.of<AppDatabase>(context, listen: false);
    _controller = HomeController(db);
    options = optionToColumnMap.keys.toList();
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: CupertinoPicker(
            backgroundColor: Colors.white,
            itemExtent: 30.0,
            onSelectedItemChanged: (int index) {
              setState(() {
                _selectedOption = options[index];
              });
            },
            children: options.map((String option) {
              return Center(child: Text(option));
            }).toList(),
          ),
        );
      },
    );
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
              dataStream: _controller.getMonthlySumOfColumnForYear(
                  optionToColumnMap[_selectedOption]!, DateTime.now().year),
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
                          Text('$_selectedOption [kW/h]: ',
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
                              stream: _controller.getLastMonthTarif(
                                  optionToColumnMap[_selectedOption]!),
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
              ],
            ),
            const SizedBox(height: 32),

            // Picker Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showPicker(context);
                },
                icon: Icon(Icons.arrow_drop_down),
                label: Text(_selectedOption),
              ),
            ),
            const SizedBox(height: 16),

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
