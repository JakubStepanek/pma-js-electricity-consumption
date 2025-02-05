import 'package:electricity_consumption_tracker/resources/app_colors.dart';
import 'package:electricity_consumption_tracker/widget/custom_button.dart';
import 'package:electricity_consumption_tracker/widget/rounded_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:electricity_consumption_tracker/database/database.dart';
import 'package:electricity_consumption_tracker/widget/yearly_consumption_chart.dart';
import 'package:electricity_consumption_tracker/navigation/app_navigation.dart';
import '../controller/home_controller.dart';
import '../widget/gradient_background.dart';

/// A stateful widget representing the home screen for the electricity consumption tracker.
///
/// This screen displays charts for electricity consumption, allows the user to select different tariff options
/// via a CupertinoPicker, and provides navigation to add new consumption entries.
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeController _controller;

  /// Mapping of user-friendly names to database column names.
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

  /// Displays a modal bottom sheet with a CupertinoPicker for tariff selection.
  ///
  /// The picker is styled with a dark CupertinoTheme.
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
            color: Colors.black,
            child: CupertinoPicker(
              backgroundColor: Colors.transparent,
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

  /// Builds the widget tree for the HomeScreen.
  ///
  /// The UI includes a gradient background, charts, tariff selection, futuristic-styled buttons,
  /// and a bottom navigation bar.
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
              // Chart with rounded background.
              RoundedBackground(
                child: YearlyConsumptionChart(
                  dataStream: _controller.getMonthlySumOfColumnForYear(
                      optionToColumnMap[_selectedOption]!, DateTime.now().year),
                  year: DateTime.now().year,
                ),
              ),
              const SizedBox(height: 16),
              // Daily average section wrapped in a rounded background.
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
                child: CustomButton(
                    onPressed: () {
                      _showPicker(context);
                    },
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.white),
                    label: _selectedOption),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/add_consumption');
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: 'Přidat odečet'),
              ),
            ],
          ),
        ),
        bottomNavigationBar: AppNavigation(),
      ),
    );
  }
}
