import 'package:electricity_consumption_tracker/utils/extensions/color_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../resources/app_colors.dart';

class YearlyConsumptionChart extends StatefulWidget {
  const YearlyConsumptionChart({super.key});

  @override
  State<StatefulWidget> createState() => _YearlyConsumptionChartState();
}

class _YearlyConsumptionChartState extends State<YearlyConsumptionChart> {
  final List<double?> _values = [800, 1000, 1400, 1500, 1300, 1000, null, 120, 1004, 1300, 1001, null];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
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
    );
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
          sideTitles: SideTitles(
            showTitles: false,
          ),
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
          // Pokud je hodnota null, vrátíme prázdnou skupinu bez sloupce
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
    // Najde nejvyšší hodnotu v seznamu a nastaví ji jako maxY
    final maxValue = _values.where((value) => value != null).reduce((a, b) => a! > b! ? a : b);
    return maxValue! * 1.1; // Přidá 10 % prostoru nad nejvyšší hodnotou
  }
}
