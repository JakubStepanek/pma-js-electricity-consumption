import 'package:electricity_consumption_tracker/controller/graph_analysis_screen_controller.dart';
import 'package:electricity_consumption_tracker/database/database.dart';
import 'package:electricity_consumption_tracker/resources/app_colors.dart';
import 'package:electricity_consumption_tracker/widget/multi_line_chart.dart';
import 'package:electricity_consumption_tracker/widget/multi_year_graph_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/gradient_background.dart'; // Reuse your gradient background widget
import '../widget/rounded_background.dart'; // Optionally extract RoundedBackground into its own file

class GraphAnalysisScreen extends StatelessWidget {
  GraphAnalysisScreen({Key? key}) : super(key: key);

  // Names and colors for the first graph – current year with all tariffs.
  final List<String> lineNames = const [
    'Nízký tarif',
    'Vysoký tarif',
    'Prodejní tarif'
  ];
  final List<Color> lineColors = const [
    AppColors.graphLineRed,
    AppColors.graphLineGreen,
    AppColors.graphLineBlue
  ];

  /// The build function returns a widget tree for a screen displaying electricity consumption data with
  /// graphs and legends.
  ///
  /// Args:
  ///   context (BuildContext): The `context` parameter in Flutter is an object that holds information
  /// about the current build context of the widget. It provides access to various properties and
  /// methods related to the widget tree, such as accessing inherited widgets, theme data, media
  /// queries, and more.
  ///
  /// Returns:
  ///   The `build` method is returning a `Provider` widget with a `GraphAnalysisScreenController`
  /// created using the `AppDatabase` provided higher in the widget tree. Inside the `Provider`, there
  /// is a `Builder` widget that builds the UI for the screen. The UI consists of a `GradientBackground`
  /// widget wrapping a `Scaffold` with an `AppBar` and a `SingleChildScrollView
  @override
  Widget build(BuildContext context) {
    return Provider<GraphAnalysisScreenController>(
      create: (context) {
        final AppDatabase db = Provider.of<AppDatabase>(context, listen: false);
        return GraphAnalysisScreenController(db);
      },
      child: Builder(
        builder: (context) {
          final GraphAnalysisScreenController controller =
              Provider.of<GraphAnalysisScreenController>(context,
                  listen: false);

          final int currentYear = DateTime.now().year;
          final List<String> columns = [
            'consumptionTarifLow',
            'consumptionTarifHigh',
            'consumptionTarifOut'
          ];

          final Stream<List<List<double?>>> dataStream =
              controller.getGraphDataStream(currentYear, columns);

          return GradientBackground(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: const Text('Detaily'),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RoundedBackground(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Graf spotřeby elektřiny - aktuální rok',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          MultiLineChart(
                            dataStream: dataStream,
                            lineNames: lineNames,
                            lineColors: lineColors,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    RoundedBackground(
                      backgroundOpacity: 0.4,
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: List.generate(lineNames.length, (index) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: lineColors[index],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                lineNames[index],
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                    const Divider(height: 32),
                    RoundedBackground(
                      child: const MultiYearGraphChart(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
