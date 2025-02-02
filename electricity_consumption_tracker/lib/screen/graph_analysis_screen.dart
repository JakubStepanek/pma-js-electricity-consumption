import 'package:electricity_consumption_tracker/controller/graph_analysis_screen_controller.dart';
import 'package:electricity_consumption_tracker/database/database.dart';
import 'package:electricity_consumption_tracker/widget/multi_line_chart.dart';
import 'package:electricity_consumption_tracker/widget/multi_year_graph_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GraphAnalysisScreen extends StatelessWidget {
  GraphAnalysisScreen({Key? key}) : super(key: key);

  // Názvy a barvy čar pro první graf – aktuální rok se všemi tarify.
  final List<String> lineNames = const [
    'Nízký tarif',
    'Vysoký tarif',
    'Prodejní tarif'
  ];
  final List<Color> lineColors = const [Colors.blue, Colors.red, Colors.green];

  @override
  Widget build(BuildContext context) {
    // Obalíme celý widget strom Providerem, který poskytne instanci GraphAnalysisScreenController.
    return Provider<GraphAnalysisScreenController>(
      create: (context) {
        // Předpokládáme, že AppDatabase je již dostupná jako Provider vyšší ve stromu.
        final AppDatabase db = Provider.of<AppDatabase>(context, listen: false);
        return GraphAnalysisScreenController(db);
      },
      child: Builder(
        builder: (context) {
          final GraphAnalysisScreenController controller =
              Provider.of<GraphAnalysisScreenController>(context, listen: false);

          final int currentYear = DateTime.now().year;
          final List<String> columns = [
            'consumptionTarifLow',
            'consumptionTarifHigh',
            'consumptionTarifOut'
          ];

          final Stream<List<List<double?>>> dataStream =
              controller.getGraphDataStream(currentYear, columns);

          return Scaffold(
            appBar: AppBar(title: const Text('Spotřeba elektřiny')),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titulek a graf pro aktuální rok se všemi tarify
                  const Text(
                    'Graf spotřeby elektřiny - aktuální rok',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  MultiLineChart(
                    dataStream: dataStream,
                    lineNames: lineNames,
                    lineColors: lineColors,
                  ),
                  const SizedBox(height: 16),
                  // Legenda pro první graf
                  Wrap(
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
                  const Divider(height: 32),
                  // Nový widget pro výběr více let pro jeden tarif
                  const MultiYearGraphChart(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
