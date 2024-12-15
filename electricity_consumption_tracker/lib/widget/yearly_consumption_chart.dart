import 'package:electricity_consumption_tracker/controller/graph_controller.dart';
import 'package:electricity_consumption_tracker/database/database.dart';
import 'package:electricity_consumption_tracker/utils/extensions/color_extensions.dart';
import 'package:electricity_consumption_tracker/utils/initialize_consumptions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../resources/app_colors.dart';

class YearlyConsumptionChart extends StatefulWidget {
  final GraphController controller;
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
  late List<double?> _values = [];

  @override
  void initState() {
    // To se volá jenom jednou při vytvoření
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    //Stream dat na základě zvoleného roku
    widget.controller.getHighTarifSumOfYear(widget.year).listen((data) {
      setState(() {
        _values = List.generate(12, (index) => data ?? 0.0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: BarChart(
        BarChartData(
          titlesData: titlesData,
          borderData: borderData,
          barGroups: _generateBarGroups(),
          gridData: const FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
          maxY: _getMaxY(),
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups() {
    return List.generate(12, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: _values.isNotEmpty ? _values[i] ?? 0 : 0,
            gradient: _barsGradient,
          )
        ],
      );
    });
  }

  double _getMaxY() {
    return (_values.isNotEmpty
            ? _values.whereType<double>().reduce((a, b) => a > b ? a : b)
            : 100) *
        1.1; //o 10 % vyšší než max
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
              fontSize: 12,
            );
            final months = [
              'Leden',
              'Ůnor',
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

  // BarTouchData get barTouchData => BarTouchData(
  //       enabled: false,
  //       touchTooltipData: BarTouchTooltipData(
  //         getTooltipColor: (group) => Colors.transparent,
  //         tooltipPadding: EdgeInsets.zero,
  //         tooltipMargin: 8,
  //         getTooltipItem: (
  //           BarChartGroupData group,
  //           int groupIndex,
  //           BarChartRodData rod,
  //           int rodIndex,
  //         ) {
  //           return BarTooltipItem(
  //             rod.toY.round().toString(),
  //             const TextStyle(
  //               color: AppColors.contentColorCyan,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           );
  //         },
  //       ),
  //     );

  // Widget getTitles(double value, TitleMeta meta) {
  //   final style = TextStyle(
  //     color: AppColors.contentColorBlue.darken(20),
  //     fontWeight: FontWeight.bold,
  //     fontSize: 12,
  //   );
  //   String text;
  //   switch (value.toInt()) {
  //     case 0:
  //       text = 'Leden';
  //       break;
  //     case 1:
  //       text = 'Únor';
  //       break;
  //     case 2:
  //       text = 'Březen';
  //       break;
  //     case 3:
  //       text = 'Duben';
  //       break;
  //     case 4:
  //       text = 'Květen';
  //       break;
  //     case 5:
  //       text = 'Červen';
  //       break;
  //     case 6:
  //       text = 'Červenec';
  //       break;
  //     case 7:
  //       text = 'Srpen';
  //       break;
  //     case 8:
  //       text = 'Září';
  //       break;
  //     case 9:
  //       text = 'Říjen';
  //       break;
  //     case 10:
  //       text = 'Listopad';
  //       break;
  //     case 11:
  //       text = 'Prosinec';
  //       break;
  //     default:
  //       text = '';
  //       break;
  //   }
  //   return SideTitleWidget(
  //     axisSide: meta.axisSide,
  //     space: 4,
  //     child: Text(text, style: style),
  //   );
  // }

  // FlTitlesData get titlesData => FlTitlesData(
  //       show: true,
  //       bottomTitles: AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: true,
  //           reservedSize: 40,
  //           getTitlesWidget: getTitles,
  //         ),
  //       ),
  //       leftTitles: const AxisTitles(
  //         sideTitles: SideTitles(showTitles: false),
  //       ),
  //       topTitles: const AxisTitles(
  //         sideTitles: SideTitles(showTitles: false),
  //       ),
  //       rightTitles: const AxisTitles(
  //         sideTitles: SideTitles(showTitles: false),
  //       ),
  //     );

  // FlBorderData get borderData => FlBorderData(
  //       show: false,
  //     );

  // LinearGradient get _barsGradient => LinearGradient(
  //       colors: [
  //         AppColors.contentColorBlue.darken(20),
  //         AppColors.contentColorCyan,
  //       ],
  //       begin: Alignment.bottomCenter,
  //       end: Alignment.topCenter,
  //     );

  // List<BarChartGroupData> get barGroups => List.generate(12, (i) {
  //       if (_values[i] == null) {
  //         return BarChartGroupData(
  //           x: i,
  //           barRods: [],
  //           showingTooltipIndicators: [],
  //         );
  //       }
  //       return BarChartGroupData(
  //         x: i,
  //         barRods: [
  //           BarChartRodData(
  //             toY: _values[i]!,
  //             gradient: _barsGradient,
  //           )
  //         ],
  //         showingTooltipIndicators: [0],
  //       );
  //     });

  // double _getMaxY() {
  //   final maxValue = _values
  //       .where((value) => value != null)
  //       .reduce((a, b) => a! > b! ? a : b);
  //   return maxValue! * 1.1;
  // }
}
