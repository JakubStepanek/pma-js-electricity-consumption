import 'package:electricity_consumption_tracker/controller/graph_analysis_screen_controller.dart';
import 'package:electricity_consumption_tracker/database/database.dart';
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
  final List<Color> lineColors = const [Colors.blue, Colors.red, Colors.green];

  @override
  Widget build(BuildContext context) {
    return Provider<GraphAnalysisScreenController>(
      create: (context) {
        // Assumes AppDatabase is provided higher in the widget tree.
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
            // Wrap the entire Scaffold in the gradient background.
            child: Scaffold(
              backgroundColor: Colors.transparent, // Let the gradient show.
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
                    // Title and chart wrapped in RoundedBackground.
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
                          // MultiLineChart takes a stream of data and displays the graph.
                          MultiLineChart(
                            dataStream: dataStream,
                            lineNames: lineNames,
                            lineColors: lineColors,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Legend wrapped in RoundedBackground (optional).
                    RoundedBackground(
                      backgroundOpacity: 0.4, // Adjust opacity as desired.
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
                    // MultiYearGraphChart widget (you can also wrap it in RoundedBackground if desired)
                    RoundedBackground(child: const MultiYearGraphChart(),),
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
