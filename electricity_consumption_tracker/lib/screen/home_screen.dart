import 'package:electricity_consumption_tracker/widget/rounded_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:electricity_consumption_tracker/database/database.dart';
import 'package:electricity_consumption_tracker/widget/yearly_consumption_chart.dart';
import 'package:electricity_consumption_tracker/navigation/app_navigation.dart';
import '../controller/home_controller.dart';
import '../widget/gradient_background.dart'; // Your gradient background widget

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeController _controller;

  // Mapping of user-friendly names to database column names.
  final Map<String, String> optionToColumnMap = {
    'Nízký tarif': 'consumptionTarifLow',
    'Vysoký tarif': 'consumptionTarifHigh',
    'Prodejní tarif': 'consumptionTarifOut',
  };

  late final List<String> options;
  String _selectedOption = 'Nízký tarif';
  DateTimeRange? _selectedDateRange;

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
      return CupertinoTheme(
        data: CupertinoThemeData(
          brightness: Brightness.dark,
          textTheme: CupertinoTextThemeData(
            pickerTextStyle: const TextStyle(color: Colors.white),
          ),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height / 3,
          color: Colors.black, // set a dark background color
          child: CupertinoPicker(
            backgroundColor: Colors.transparent, // let the theme show through
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
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return GradientBackground(
      // Wrap entire screen with your gradient background.
      child: Scaffold(
        backgroundColor: Colors.transparent, // Let the gradient show.
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Spotřeba elektřiny'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wrap the chart widget in RoundedBackground.
              RoundedBackground(
                child: YearlyConsumptionChart(
                  dataStream: _controller.getMonthlySumOfColumnForYear(
                      optionToColumnMap[_selectedOption]!, DateTime.now().year),
                  year: DateTime.now().year,
                ),
              ),
              const SizedBox(height: 16),
              // Wrap statistics text in RoundedBackground.
              RoundedBackground(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Denní průměr tento měsíc:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            '$_selectedOption [kW/h]: ',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.normal),
                          ),
                        ),
                        Expanded(
                          child: StreamBuilder<double?>(
                              stream: _controller.getAverageLastMonthTarif(
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
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                  textAlign: TextAlign.end,
                                );
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showPicker(context);
                  },
                  icon: const Icon(Icons.arrow_drop_down),
                  label: Text(_selectedOption),
                ),
              ),

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/add_consumption');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Přidat odečet'),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: AppNavigation(),
      ),
    );
  }
}
