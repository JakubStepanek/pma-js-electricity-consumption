import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class YearlyConsumptionChart extends StatelessWidget {
  final List<double> monthlyConsumption;

  const YearlyConsumptionChart({Key? key, required this.monthlyConsumption})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 200, // Nastavte maximální hodnotu dle vašich dat
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toStringAsFixed(1)} kWh',
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (double value, TitleMeta meta) {
                const months = [
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
                  space: 8.0,
                  child: Text(
                    months[value.toInt()],
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text('${value.toInt()} kWh');
              },
            ),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: monthlyConsumption.asMap().entries.map((entry) {
          final index = entry.key;
          final value = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: value,
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlue],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ],
            showingTooltipIndicators: [0],
          );
        }).toList(),
      ),
    );
  }
}
