import 'package:electricity_consumption_tracker/utils/extensions/color_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../resources/app_colors.dart';

class YearlyConsumptionChart extends StatelessWidget {
  final Stream<List<double?>> dataStream; // Stream dat
  final int year;

  const YearlyConsumptionChart({
    required this.dataStream,
    required this.year,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<double?>>(
      stream: dataStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Chyba při načítání dat");
        }

        if (!snapshot.hasData) {
          return const CircularProgressIndicator(); // Načítání dat
        }

        final data = snapshot.data!; // Data z streamu
        return AspectRatio(
          aspectRatio: 1.2,
          child: BarChart(
            BarChartData(
              titlesData: _buildTitlesData(),
              borderData: _buildBorderData(),
              barGroups: _generateBarGroups(data),
              gridData: const FlGridData(show: false),
              alignment: BarChartAlignment.spaceAround,
              maxY: _calculateMaxY(data),
            ),
          ),
        );
      },
    );
  }

  List<BarChartGroupData> _generateBarGroups(List<double?> data) {
    return List.generate(12, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: data.isNotEmpty ? data[i] ?? 0 : 0,
            gradient: _buildBarsGradient(),
          )
        ],
      );
    });
  }

  double _calculateMaxY(List<double?> data) {
    return (data.isNotEmpty
            ? data.whereType<double>().reduce((a, b) => a > b ? a : b)
            : 100) *
        1.1; // o 10 % vyšší než max
  }

  LinearGradient _buildBarsGradient() => LinearGradient(
        colors: [
          AppColors.contentColorBlue.darken(20),
          AppColors.contentColorCyan,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  FlTitlesData _buildTitlesData() => FlTitlesData(
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

  FlBorderData _buildBorderData() => FlBorderData(show: false);
}
