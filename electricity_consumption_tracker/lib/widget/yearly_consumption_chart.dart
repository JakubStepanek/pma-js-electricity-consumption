import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../resources/app_colors.dart';
import 'package:electricity_consumption_tracker/utils/extensions/color_extensions.dart';

/// A widget that displays a bar chart representing monthly consumption data for a specific year.
///
/// The [YearlyConsumptionChart] widget listens to a [Stream] of data (a list of nullable doubles),
/// calculates appropriate dimensions based on the screen width, and renders a [BarChart] from the
/// [fl_chart] package. It also provides custom tooltips, axis titles, and gradient coloring for the bars.
class YearlyConsumptionChart extends StatelessWidget {
  /// The stream of consumption data.
  ///
  /// Each element in the stream is a list of nullable doubles representing monthly consumption values.
  final Stream<List<double?>> dataStream;

  /// The year corresponding to the displayed data.
  final int year;

  /// Creates a [YearlyConsumptionChart] widget.
  ///
  /// [dataStream] must provide the monthly consumption data.
  /// [year] indicates the year for which the data is displayed.
  const YearlyConsumptionChart({
    required this.dataStream,
    required this.year,
    super.key,
  });

  /// Builds the widget tree.
  ///
  /// Uses a [StreamBuilder] to listen to [dataStream]. If data is available, it calculates the bar width and spacing based on the
  /// screen width, then renders a [BarChart] inside a fixed height [SizedBox]. If an error occurs or no data is present,
  /// appropriate messages are displayed.
  @override
  Widget build(BuildContext context) {
    // Retrieve screen width from MediaQuery for calculating bar dimensions.
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<List<double?>>(
      stream: dataStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Chyba při načítání dat");
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;
        // Calculate bar width and spacing based on the available screen width.
        final barWidth = screenWidth / (data.length * 2.5);
        final groupsSpace =
            (screenWidth - (barWidth * data.length)) / (data.length + 1);

        // Use Padding and a fixed height SizedBox to display the chart.
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 300, // Adjust the height here as needed.
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                groupsSpace: groupsSpace,
                barGroups: _generateBarGroups(data, barWidth),
                titlesData: _buildTitlesData(),
                borderData: _buildBorderData(),
                gridData: FlGridData(show: false),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => Colors.black87,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toStringAsFixed(2)} kWh',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      );
                    },
                  ),
                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    if (!event.isInterestedForInteractions ||
                        barTouchResponse == null ||
                        barTouchResponse.spot == null) {
                      return;
                    }
                    // Additional touch handling if needed.
                  },
                ),
                maxY: _calculateMaxY(data),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Generates the bar groups for the chart.
  ///
  /// Each element in the [data] list is mapped to a [BarChartGroupData] containing a single [BarChartRodData].
  /// The x-coordinate is the index of the data point and the y-coordinate is the consumption value (defaulting to 0 if null).
  ///
  /// Args:
  ///   data: A list of nullable doubles representing monthly consumption values.
  ///   barWidth: The calculated width for each bar.
  ///
  /// Returns:
  ///   A list of [BarChartGroupData] objects to be used in the bar chart.
  List<BarChartGroupData> _generateBarGroups(
      List<double?> data, double barWidth) {
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

  /// Calculates the maximum y-axis value for the chart.
  ///
  /// This method extracts all non-null double values from [data] and finds the maximum value.
  /// If no valid values are found, it returns 100. Otherwise, it returns 110% of the maximum value
  /// to provide headroom on the chart.
  ///
  /// Args:
  ///   data: A list of nullable doubles representing monthly consumption values.
  ///
  /// Returns:
  ///   A [double] representing the maximum y value for the chart.
  double _calculateMaxY(List<double?> data) {
    return (data.isNotEmpty
            ? data.whereType<double>().reduce((a, b) => a > b ? a : b)
            : 100) *
        1.1;
  }

  /// Builds the gradient applied to the bars.
  ///
  /// Uses colors from [AppColors] and a custom extension method `darken` to modify the color.
  /// The gradient is applied vertically from the bottom to the top of each bar.
  ///
  /// Returns:
  ///   A [LinearGradient] used to fill the bars.
  LinearGradient _buildBarsGradient() => LinearGradient(
        colors: [
          AppColors.contentColorGreen.darken(20),
          AppColors.contentColorRed,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  /// Builds the titles (axis labels) for the bar chart.
  ///
  /// Configures the bottom axis to display abbreviated month names and the left axis to display numeric values.
  /// Right and top titles are disabled.
  ///
  /// Returns:
  ///   An [FlTitlesData] object containing the configuration for the axis titles.
  FlTitlesData _buildTitlesData() => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 20,
            getTitlesWidget: (value, meta) {
              final style = TextStyle(
                color: AppColors.contentColorWhite.darken(20),
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
              if (value.toInt() >= 0 && value.toInt() < months.length) {
                return SideTitleWidget(
                  fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
                  meta: meta,
                  space: 4, // Reduced space from 4 to 2
                  child: Text(months[value.toInt()], style: style),
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
                color: AppColors.contentColorWhite.darken(20),
                fontWeight: FontWeight.bold,
                fontSize: 10,
              );
              return SideTitleWidget(
                fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
                meta: meta,
                space: 4, // Reduced space from 4 to 2
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

  /// Builds the border configuration for the bar chart.
  ///
  /// Only the bottom and left borders are displayed, both with a blue color and a width of 1 pixel.
  /// The right and top borders are disabled.
  ///
  /// Returns:
  ///   An [FlBorderData] object with the defined border settings.
  FlBorderData _buildBorderData() => FlBorderData(
        show: true,
        border: Border(
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
