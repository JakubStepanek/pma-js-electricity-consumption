import 'package:electricity_consumption_tracker/controller/graph_analysis_screen_controller.dart';
import 'package:electricity_consumption_tracker/widget/multi_line_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

/// A stateful widget that displays a multi-year graph chart based on consumption data.
///
/// The widget allows the user to select one or more years and a tariff type. It then
/// builds a combined data stream from the provided [GraphAnalysisScreenController] and
/// renders a multiline chart using the [MultiLineChart] widget.
class MultiYearGraphChart extends StatefulWidget {
  const MultiYearGraphChart({Key? key}) : super(key: key);

  @override
  _MultiYearGraphChartState createState() => _MultiYearGraphChartState();
}

/// The state for [MultiYearGraphChart].
///
/// Maintains the list of selected years and the currently selected tariff. It also fetches the
/// available years from the [GraphAnalysisScreenController] and builds a combined data stream
/// used by the chart.
class _MultiYearGraphChartState extends State<MultiYearGraphChart> {
  /// List of years selected by the user. Defaults to the current year.
  List<int> selectedYears = [DateTime.now().year];

  /// The currently selected tariff.
  String selectedTariff = 'Nízký tarif';

  /// A map linking the display names of tariffs to their corresponding database column names.
  final Map<String, String> tariffColumnMap = {
    'Nízký tarif': 'consumptionTarifLow',
    'Vysoký tarif': 'consumptionTarifHigh',
    'Prodejní tarif': 'consumptionTarifOut',
  };

  /// Future that fetches the list of available unique years from the controller.
  Future<List<int>>? _availableYearsFuture;

  /// Called when the dependencies of this widget change.
  ///
  /// This method initializes [_availableYearsFuture] if it hasn't been already set, by fetching
  /// the unique years from the [GraphAnalysisScreenController].
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_availableYearsFuture == null) {
      final controller =
          Provider.of<GraphAnalysisScreenController>(context, listen: false);
      _availableYearsFuture = controller.getUniqueYears();
    }
  }

  /// Builds the widget tree.
  ///
  /// The UI includes:
  /// - A title and a dropdown for selecting the tariff.
  /// - A set of [FilterChip] widgets representing the available years.
  /// - Depending on the selection, either a message prompting the user to select at least one year,
  ///   or the multiline chart displaying the consumption data.
  @override
  Widget build(BuildContext context) {
    // Retrieve the controller from the provider.
    final GraphAnalysisScreenController controller =
        Provider.of<GraphAnalysisScreenController>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Porovnání let',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // Dropdown for selecting the tariff.
        Row(
          children: [
            const Text('Tarif: '),
            DropdownButton<String>(
              value: selectedTariff,
              items: tariffColumnMap.keys.map((tariff) {
                return DropdownMenuItem<String>(
                  value: tariff,
                  child: Text(tariff),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedTariff = value;
                  });
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        // FutureBuilder for available years.
        FutureBuilder<List<int>>(
          future: _availableYearsFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final availableYears = snapshot.data!;
            return Wrap(
              spacing: 8,
              children: availableYears.map((year) {
                return FilterChip(
                  label: Text(year.toString()),
                  selected: selectedYears.contains(year),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedYears.add(year);
                      } else {
                        selectedYears.remove(year);
                      }
                      selectedYears.sort();
                    });
                  },
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 8),
        // If no years are selected, show an error message; otherwise display the chart.
        if (selectedYears.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Vyberte alespoň jeden rok pro zobrazení grafu.',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ),
          )
        else
          FutureBuilder<Stream<List<List<double?>>>>(
            future: _buildCombinedDataStream(controller),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final dataStream = snapshot.data!;
              final int shiftFactor = 3;
              // Generate colors for each selected year.
              final List<Color> generatedLineColors = List.generate(
                selectedYears.length,
                (index) => Colors
                    .primaries[(index * shiftFactor) % Colors.primaries.length],
              );
              return AspectRatio(
                aspectRatio: 1.2,
                child: MultiLineChart(
                  dataStream: dataStream,
                  lineNames:
                      selectedYears.map((year) => year.toString()).toList(),
                  lineColors: generatedLineColors,
                ),
              );
            },
          ),
      ],
    );
  }

  /// Builds a combined data stream from multiple years.
  ///
  /// For each selected year, this method fetches a data stream using the [GraphAnalysisScreenController]
  /// and extracts the first list of double values from the stream. All individual streams are then combined
  /// using [CombineLatestStream.list] into a single stream that provides data for the multiline chart.
  ///
  /// Args:
  ///   controller: An instance of [GraphAnalysisScreenController] used to fetch the data.
  ///
  /// Returns:
  ///   A [Future] that resolves to a [Stream] of a list of lists of nullable doubles. Each inner list corresponds
  ///   to the data points for one selected year.
  Future<Stream<List<List<double?>>>> _buildCombinedDataStream(
      GraphAnalysisScreenController controller) async {
    final String column = tariffColumnMap[selectedTariff]!;
    final List<Stream<List<double?>>> streams = selectedYears.map((year) {
      return controller.getGraphDataStream(
          year, [column]).map((listOfLists) => listOfLists.first);
    }).toList();

    return CombineLatestStream.list(streams).map((listOfData) {
      return listOfData;
    });
  }
}
