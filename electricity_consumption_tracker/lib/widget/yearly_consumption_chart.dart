import 'package:electricity_consumption_tracker/utils/extensions/color_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../resources/app_colors.dart';

class YearlyConsumptionChart extends StatelessWidget {
  final Stream<List<double?>> dataStream;
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
          return const CircularProgressIndicator();
        }

        final data = snapshot.data!;
        final screenWidth = MediaQuery.of(context).size.width;
        final barWidth = screenWidth / (data.length * 2.5);
        final groupsSpace = (screenWidth - (barWidth * data.length)) / (data.length + 1);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: screenWidth,
            child: AspectRatio(
              aspectRatio: 1.2,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  groupsSpace: groupsSpace,
                  barGroups: _generateBarGroups(data, barWidth),
                  titlesData: _buildTitlesData(),
                  borderData: _buildBorderData(),
                  gridData: FlGridData(show: false), // Hide grid lines
                  maxY: _calculateMaxY(data),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<BarChartGroupData> _generateBarGroups(List<double?> data, double barWidth) {
    return List.generate(data.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: data[i] ?? 0,
            gradient: _buildBarsGradient(),
            width: barWidth,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }

  double _calculateMaxY(List<double?> data) {
    return (data.isNotEmpty
            ? data.whereType<double>().reduce((a, b) => a > b ? a : b)
            : 100) *
        1.1;
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
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              final style = TextStyle(
                color: AppColors.contentColorBlue.darken(20),
                fontWeight: FontWeight.bold,
                fontSize: 10,
              );
              final months = [
                'Led',
                'Úno',
                'Bře',
                'Dub',
                'Kvě',
                'Čvn',
                'Čvc',
                'Srp',
                'Zář',
                'Říj',
                'Lis',
                'Pro',
              ];
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 4,
                child: Transform.rotate(
                  angle: -30 * 3.1415927 / 180,
                  child: Text(months[value.toInt()], style: style),
                ),
              );
            },
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              final style = TextStyle(
                color: AppColors.contentColorBlue.darken(20),
                fontWeight: FontWeight.bold,
                fontSize: 10,
              );
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 4,
                child: Text(value.toInt().toString(), style: style),
              );
            },
          ),
        ),
      );

  FlBorderData _buildBorderData() => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
            color: AppColors.contentColorBlue,
            width: 1,
          ),
          left: BorderSide(
            color: AppColors.contentColorBlue,
            width: 1,
          ),
        ),
      );
}
