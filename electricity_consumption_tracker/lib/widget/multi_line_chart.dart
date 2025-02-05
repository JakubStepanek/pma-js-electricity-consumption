import 'package:electricity_consumption_tracker/resources/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// A stateless widget that displays a multiline chart based on streaming data, with error handling and tooltips.
///
/// The [MultiLineChart] widget renders a line chart using data provided via a [Stream]. It supports multiple lines,
/// custom tooltips for data points, and dynamic styling via the [lineNames] and [lineColors] parameters.
class MultiLineChart extends StatelessWidget {
  /// The stream providing the chart data.
  ///
  /// Each element in the stream is a list of lists of nullable doubles. Each inner list represents a set of data
  /// points for one line in the chart.
  final Stream<List<List<double?>>> dataStream;

  /// The names for each line.
  ///
  /// These names are used in tooltips to identify individual lines. If there are fewer names than lines,
  /// a default name is used.
  final List<String> lineNames;

  /// The colors for each line.
  ///
  /// The colors are applied cyclically if the number of lines exceeds the length of this list.
  final List<Color> lineColors;

  /// Creates a [MultiLineChart] widget.
  ///
  /// All parameters are required.
  const MultiLineChart({
    required this.dataStream,
    required this.lineNames,
    required this.lineColors,
    Key? key,
  }) : super(key: key);

  /// Builds the widget tree.
  ///
  /// Uses a [StreamBuilder] to listen to the [dataStream] and rebuild the chart whenever new data arrives.
  /// If an error occurs or no data is available, an appropriate message is displayed.
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
                      // Tooltip se vejde uvnitř obrazovky
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

  /// Generates a list of [LineChartBarData] objects based on the input [data].
  ///
  /// Each inner list in [data] is converted to a list of [FlSpot] objects, where the x-coordinate corresponds
  /// to the index and the y-coordinate corresponds to the data value (defaulting to 0 if null).
  ///
  /// Returns a list of [LineChartBarData] representing each line of the chart.
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

  /// Calculates the maximum y-axis value for the chart.
  ///
  /// It extracts all non-null double values from [data] and returns 110% of the maximum value to provide headroom.
  /// If no valid values are found, 100 is returned.
  ///
  /// Returns the calculated maximum y value as a [double].
  double _calculateMaxY(List<List<double?>> data) {
    final allValues = data.expand((list) => list).whereType<double>();
    if (allValues.isEmpty) {
      return 100;
    }
    final maxValue = allValues.reduce((a, b) => a > b ? a : b);
    return maxValue * 1.1;
  }


  /// Builds the titles (axis labels) for the chart.
  ///
  /// Configures the bottom axis to display abbreviated month names and the left axis to display numeric values.
  /// The right and top axes have their titles disabled.
  ///
  /// Returns an [FlTitlesData] object with the title configuration.
  FlTitlesData _buildTitlesData() => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              final style = TextStyle(
                color: AppColors.contentColorWhite,
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
                  fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
                  meta: meta,
                  space: 8,
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
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              final style = TextStyle(
                color: AppColors.contentColorWhite,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              );
              return SideTitleWidget(
                fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
                meta: meta,
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

  /// Builds the border configuration for the chart.
  ///
  /// Only the bottom and left borders are shown, both with a white color and a width of 1 pixel.
  /// The right and top borders are hidden.
  ///
  /// Returns an [FlBorderData] object with the defined border settings.
  FlBorderData _buildBorderData() => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: AppColors.contentColorWhite,
            width: 1,
          ),
          left: BorderSide(
            color: AppColors.contentColorWhite,
            width: 1,
          ),
          right: BorderSide.none,
          top: BorderSide.none,
        ),
      );
}
