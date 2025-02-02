import 'package:electricity_consumption_tracker/controller/graph_analysis_screen_controller.dart';
import 'package:electricity_consumption_tracker/widget/multi_line_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class MultiYearGraphChart extends StatefulWidget {
  const MultiYearGraphChart({Key? key}) : super(key: key);

  @override
  _MultiYearGraphChartState createState() => _MultiYearGraphChartState();
}

class _MultiYearGraphChartState extends State<MultiYearGraphChart> {
  // Seznam vybraných let – budeme jej měnit dle výběru uživatele.
  List<int> selectedYears = [DateTime.now().year];

  // Vybraný tarif – pouze jeden najednou.
  String selectedTariff = 'Nízký tarif';

  // Mapa, která propojuje název tarifu s názvem sloupce v databázi.
  final Map<String, String> tariffColumnMap = {
    'Nízký tarif': 'consumptionTarifLow',
    'Vysoký tarif': 'consumptionTarifHigh',
    'Prodejní tarif': 'consumptionTarifOut',
  };

  // Budeme uchovávat budoucí hodnotu dostupných let, získaných z databáze.
  Future<List<int>>? _availableYearsFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Načteme unikátní roky z databáze pouze jednou.
    if (_availableYearsFuture == null) {
      final controller =
          Provider.of<GraphAnalysisScreenController>(context, listen: false);
      _availableYearsFuture = controller.getUniqueYears();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Získáme instanci controlleru z Provideru.
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
        // Výběr tarifu pomocí DropdownButton.
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
        // FutureBuilder načítá dostupné roky z databáze.
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
                      selectedYears.sort(); // Pro konzistentní pořadí.
                    });
                  },
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 8),
        // Pokud nebyl vybrán žádný rok, zobrazíme informační text místo grafu.
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
// Generování seznamu barev – počet barev odpovídá počtu vybraných let a mezi nimi je použit shift factor.
              final int shiftFactor = 3;
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

  /// Pro každý vybraný rok získá stream dat pro zvolený tarif a pak je kombinuje.
  Future<Stream<List<List<double?>>>> _buildCombinedDataStream(
      GraphAnalysisScreenController controller) async {
    // Vybraný sloupec podle tarifu.
    final String column = tariffColumnMap[selectedTariff]!;
    // Pro každý vybraný rok získáme stream – při předání jednoho sloupce bude výsledný seznam obsahovat pouze jeden prvek.
    final List<Stream<List<double?>>> streams = selectedYears.map((year) {
      return controller.getGraphDataStream(
          year, [column]).map((listOfLists) => listOfLists.first);
    }).toList();

    // Kombinujeme všechny streamy do jednoho pomocí CombineLatestStream z RxDart.
    return CombineLatestStream.list(streams).map((listOfData) {
      // Vracíme List<List<double?>>: každý prvek odpovídá datům pro jeden rok.
      return listOfData;
    });
  }
}
