import 'package:electricity_consumption_tracker/controller/graph_controller.dart';
import 'package:electricity_consumption_tracker/database/database.dart';
import 'package:electricity_consumption_tracker/utils/extensions/color_extensions.dart';
import 'package:electricity_consumption_tracker/utils/initialize_consumptions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../resources/app_colors.dart';

class YearlyConsumptionChart extends StatefulWidget {
  const YearlyConsumptionChart({super.key});

  @override
  State<StatefulWidget> createState() => _YearlyConsumptionChartState();
}

class _YearlyConsumptionChartState extends State<YearlyConsumptionChart> {
  late GraphController _controller;

  final List<double?> _values = [
    800,
    1000,
    1400,
    1500,
    1300,
    1000,
    null,
    120,
    1004,
    1300,
    1001,
    null
  ];

  // Dropdown options
  final List<String> _tariffs = ['Nízký', 'Vysoký', 'Prodej'];
  final List<int> _years = [];

  // Selected options
  String _selectedTariff = 'Nízký';
  int _selectedYear = 2023;

  @override
  void initState() {
    // To se volá jenom jednou při vytvoření
    super.initState();
    final db = Provider.of<AppDatabase>(context, listen: false);
    _controller = GraphController(db);
    initializeConsumptions(db);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Dropdown pro výběr tarifu
            DropdownButton<String>(
              value: _selectedTariff,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTariff = newValue!;
                  // Logika pro změnu dat podle tarifu
                  _updateDataForTariff(_selectedTariff);
                });
              },
              items: _tariffs.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            // Dropdown pro výběr roku
            DropdownButton<int>(
              value: _selectedYear,
              onChanged: (int? newValue) {
                setState(() {
                  _selectedYear = newValue!;
                  // Logika pro změnu dat podle roku
                  _updateDataForYear(_selectedYear);
                });
              },
              items: _years.map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 16), // Oddělení dropdownů od grafu
        AspectRatio(
          aspectRatio: 1.6,
          child: BarChart(
            BarChartData(
              barTouchData: barTouchData,
              titlesData: titlesData,
              borderData: borderData,
              barGroups: barGroups,
              gridData: const FlGridData(show: false),
              alignment: BarChartAlignment.spaceAround,
              maxY: _getMaxY(),
            ),
          ),
        ),
      ],
    );
  }

  // Logika pro změnu dat podle tarifu
  void _updateDataForTariff(String tariff) {
    // Zde by byla logika pro načtení nebo úpravu dat pro zvolený tarif
    if (tariff == 'Nízký') {
      _values.setAll(0, [
        8000,
        100000,
        1400,
        1500,
        1300,
        1000,
        null,
        120,
        1004,
        1300,
        1001,
        null
      ]);
    } else if (tariff == 'Vysoký') {
      _values.setAll(0, [
        10000,
        90000,
        1200,
        1800,
        1500,
        2000,
        null,
        200,
        1500,
        1700,
        1200,
        null
      ]);
    } else if (tariff == 'Prodej') {
      _values.setAll(0, [
        15000,
        80000,
        2000,
        2500,
        2300,
        3000,
        null,
        500,
        1700,
        1800,
        1500,
        null
      ]);
    }
  }

  // Logika pro změnu dat podle roku
  void _updateDataForYear(int year) {
    // Zde by byla logika pro načtení nebo úpravu dat podle roku
    if (year == 2023) {
      _values.setAll(0, [
        8000,
        100000,
        1400,
        1500,
        1300,
        1000,
        null,
        120,
        1004,
        1300,
        1001,
        null
      ]);
    } else if (year == 2022) {
      _values.setAll(0, [
        5000,
        70000,
        1100,
        1300,
        1100,
        900,
        null,
        100,
        800,
        1200,
        900,
        null
      ]);
    } else if (year == 2021) {
      _values.setAll(0,
          [3000, 50000, 900, 1100, 800, 700, null, 50, 600, 1000, 700, null]);
    }
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: AppColors.contentColorCyan,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: AppColors.contentColorBlue.darken(20),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Leden';
        break;
      case 1:
        text = 'Únor';
        break;
      case 2:
        text = 'Březen';
        break;
      case 3:
        text = 'Duben';
        break;
      case 4:
        text = 'Květen';
        break;
      case 5:
        text = 'Červen';
        break;
      case 6:
        text = 'Červenec';
        break;
      case 7:
        text = 'Srpen';
        break;
      case 8:
        text = 'Září';
        break;
      case 9:
        text = 'Říjen';
        break;
      case 10:
        text = 'Listopad';
        break;
      case 11:
        text = 'Prosinec';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          AppColors.contentColorBlue.darken(20),
          AppColors.contentColorCyan,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => List.generate(12, (i) {
        if (_values[i] == null) {
          return BarChartGroupData(
            x: i,
            barRods: [],
            showingTooltipIndicators: [],
          );
        }
        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: _values[i]!,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        );
      });

  double _getMaxY() {
    final maxValue = _values
        .where((value) => value != null)
        .reduce((a, b) => a! > b! ? a : b);
    return maxValue! * 1.1;
  }
}
