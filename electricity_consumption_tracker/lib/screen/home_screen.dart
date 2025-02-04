import 'package:electricity_consumption_tracker/widget/rounded_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:electricity_consumption_tracker/database/database.dart';
import 'package:electricity_consumption_tracker/widget/yearly_consumption_chart.dart';
import 'package:electricity_consumption_tracker/navigation/app_navigation.dart';
import '../controller/home_controller.dart';
import '../widget/gradient_background.dart';

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

  /// The _showPicker function displays a modal bottom sheet with a CupertinoPicker widget in a dark
  /// theme.
  ///
  /// Args:
  ///   context (BuildContext): The `context` parameter in Flutter represents the build context of the
  /// widget that is currently being built. It provides access to various properties and methods related
  /// to the widget tree, such as theme, size, and localization.
  ///
  /// Returns:
  ///   A `CupertinoTheme` widget is being returned, which contains a `Container` widget with a
  /// `CupertinoPicker` widget inside. The `CupertinoPicker` widget displays a list of options for the
  /// user to choose from.
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

  /// The build function returns a widget tree for a screen displaying electricity consumption data with
  /// charts and buttons for user interaction.
  ///
  /// Args:
  ///   context (BuildContext): The `context` parameter in Flutter represents the build context of the
  /// widget. It is a reference to the location of a widget within the widget tree. The context provides
  /// access to various properties and methods related to the widget, such as theme data, media queries,
  /// and navigation.
  ///
  /// Returns:
  ///   The build method is returning a Widget tree that consists of a GradientBackground widget as the
  /// root, which contains a Scaffold widget. Inside the Scaffold, there is an AppBar with a title, a
  /// body that includes a SingleChildScrollView with multiple child widgets such as RoundedBackground,
  /// YearlyConsumptionChart, Text widgets, Row widget, ElevatedButton widgets, and more. The
  /// bottomNavigationBar is set to an AppNavigation
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
              RoundedBackground(
                child: YearlyConsumptionChart(
                  dataStream: _controller.getMonthlySumOfColumnForYear(
                      optionToColumnMap[_selectedOption]!, DateTime.now().year),
                  year: DateTime.now().year,
                ),
              ),
              const SizedBox(height: 16),
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
