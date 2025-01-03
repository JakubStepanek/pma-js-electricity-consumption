import 'package:electricity_consumption_tracker/controller/home_controller.dart';
import 'package:electricity_consumption_tracker/utils/extensions/color_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../resources/app_colors.dart';

class YearlyConsumptionChart extends StatefulWidget {
  final HomeController controller;
  final int year;

  const YearlyConsumptionChart({
    required this.controller,
    required this.year,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _YearlyConsumptionChartState();
}

class _YearlyConsumptionChartState extends State<YearlyConsumptionChart> {
  late Stream<List<double?>> _valuesStream;

  @override
  void initState() {
    super.initState();
    // Inicializace streamu pro měsíční součty spotřeby
    _valuesStream = widget.controller.getMonthlySumOfColumnForYear("consumptionTarifHigh", widget.year);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: StreamBuilder<List<double?>>(
        stream: _valuesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Chyba: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Žádná data k zobrazení'));
          } else {
            final values = snapshot.data!;
            return BarChart(
              BarChartData(
                titlesData: titlesData,
                borderData: borderData,
                barGroups: _generateBarGroups(values),
                gridData: const FlGridData(show: false),
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxY(values),
              ),
            );
          }
        },
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups(List<double?> values) {
    return List.generate(12, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: values[i] ?? 0,
            gradient: _barsGradient,
          )
        ],
      );
    });
  }

  double _getMaxY(List<double?> values) {
    final maxValue = values.whereType<double>().reduce((a, b) => a > b ? a : b);
    return maxValue * 1.1; // o 10 % vyšší než max
  }

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          AppColors.contentColorBlue.darken(20),
          AppColors.contentColorCyan,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  FlTitlesData get titlesData => FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            final style = TextStyle(
              color: AppColors.contentColorBlue.darken(20),
              fontWeight: FontWeight.bold,
              fontSize: 8,
            );
            final months = [
              'Leden',
              'Únor',
              'Březen',
              'Duben',
              'Květen',
              'Červen',
              'Červenec',
              'Srpen',
              'Září',
              'Říjen',
              'Listopad',
              'Prosinec',
            ];
            return SideTitleWidget(
              axisSide: meta.axisSide,
              space: 4,
              child: Text(months[value.toInt()], style: style),
            );
          },
        ),
      ),
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)));

  FlBorderData get borderData => FlBorderData(show: false);
}
