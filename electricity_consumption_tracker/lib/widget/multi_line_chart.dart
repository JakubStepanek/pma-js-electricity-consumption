import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MultiLineChart extends StatelessWidget {
  final Stream<List<List<double?>>> dataStream;
  final List<String> lineNames;
  final List<Color> lineColors;

  const MultiLineChart({
    required this.dataStream,
    required this.lineNames,
    required this.lineColors,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<List<double?>>>(
      stream: dataStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Chyba při načítání dat");
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("Žádná data k zobrazení");
        }

        final data = snapshot.data!;
        final screenWidth = MediaQuery.of(context).size.width;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: screenWidth,
            child: AspectRatio(
              aspectRatio: 1.2,
              child: LineChart(
                LineChartData(
                  lineBarsData: _generateLineBarsData(data),
                  titlesData: _buildTitlesData(),
                  borderData: _buildBorderData(),
                  gridData: FlGridData(show: false),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      // Přidáno, aby tooltip zůstal uvnitř obrazovky
                      fitInsideHorizontally: true,
                      fitInsideVertically: true,
                      getTooltipColor: (LineBarSpot spot) => Colors.black87,
                      tooltipPadding: const EdgeInsets.all(8),
                      tooltipMargin: 8,
                      tooltipRoundedRadius: 8,
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((spot) {
                          final lineName = lineNames.length > spot.barIndex
                              ? lineNames[spot.barIndex]
                              : 'Line ${spot.barIndex + 1}';
                          return LineTooltipItem(
                            '$lineName: ${spot.y.toStringAsFixed(2)} kWh',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  maxY: _calculateMaxY(data),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<LineChartBarData> _generateLineBarsData(List<List<double?>> data) {
    return List.generate(data.length, (i) {
      return LineChartBarData(
        spots: data[i]
            .asMap()
            .entries
            .map((entry) => FlSpot(entry.key.toDouble(), entry.value ?? 0))
            .toList(),
        isCurved: true,
        color: lineColors[i % lineColors.length],
        barWidth: 2,
        dotData: FlDotData(show: false),
      );
    });
  }

  double _calculateMaxY(List<List<double?>> data) {
    final allValues = data.expand((list) => list).whereType<double>();
    if (allValues.isEmpty) {
      return 100;
    }
    final maxValue = allValues.reduce((a, b) => a > b ? a : b);
    return maxValue * 1.1;
  }

  FlTitlesData _buildTitlesData() => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              final style = TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              );
              final labels = [
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
              if (value.toInt() >= 0 && value.toInt() < labels.length) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 4,
                  child: Text(labels[value.toInt()], style: style),
                );
              } else {
                return const SizedBox.shrink();
              }
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
                color: Colors.blue.shade700,
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
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData _buildBorderData() => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Colors.blue,
            width: 1,
          ),
          left: BorderSide(
            color: Colors.blue,
            width: 1,
          ),
          right: BorderSide.none,
          top: BorderSide.none,
        ),
      );
}
