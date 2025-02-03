import 'dart:io';
import 'package:electricity_consumption_tracker/database/database.dart';
import 'package:electricity_consumption_tracker/widget/custom_text_form_field_not_null.dart';
import 'package:electricity_consumption_tracker/widget/custom_text_form_field_optional.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

class AddConsumptionScreen extends StatefulWidget {
  const AddConsumptionScreen({Key? key}) : super(key: key);

  @override
  _AddConsumptionScreenState createState() => _AddConsumptionScreenState();
}

class _AddConsumptionScreenState extends State<AddConsumptionScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _lowTariffController;
  final TextEditingController _highTariffController = TextEditingController();
  final TextEditingController _outTariffController = TextEditingController();
  bool _isProcessing = false;

  @override
  void initState() {
    _lowTariffController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _lowTariffController.dispose();
    _highTariffController.dispose();
    _outTariffController.dispose();
    super.dispose();
  }

  /// Metoda, která provádí OCR pro konkrétní form field.
  /// Po vyfocení obrázku se pomocí FlutterTesseractOcr extrahuje text a poté
  /// pomocí regulárního výrazu hledá první číselnou hodnotu, která je následně
  /// vložena do zadaného controlleru.
  Future<void> _performOCRForField(TextEditingController controller) async {
    final picker = ImagePicker();
    // Získání obrázku z kamery. Pro galerii lze změnit ImageSource.gallery.
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return; // Uživatel zrušil výběr obrázku

    setState(() {
      _isProcessing = true;
    });

    try {
      // Extrakce textu z obrázku pomocí Tesseract OCR.
      String recognizedText = await FlutterTesseractOcr.extractText(
        pickedFile.path,
        language: 'eng', // Je-li potřeba, lze změnit jazyk
      );

      // Použití regulárního výrazu k nalezení první číselné hodnoty.
      final RegExp regExp = RegExp(r'\d+(\.\d+)?');
      final matches = regExp.allMatches(recognizedText).toList();

      if (matches.isNotEmpty) {
        controller.text = matches[0].group(0)!;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Nebyl nalezen žádný numerický odečet.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Došlo k chybě při zpracování OCR: $e')),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  /// Metoda pro uložení záznamu do databáze.
  void addConsumption() {
    final isValid = _formKey.currentState?.validate();
    if (isValid != null && isValid) {
      final entity = ConsumptionsCompanion(
        date: drift.Value(DateTime.now()),
        consumptionTarifHigh:
            drift.Value(double.parse(_highTariffController.text)),
        consumptionTarifLow:
            drift.Value(double.parse(_lowTariffController.text)),
        consumptionTarifOut:
            drift.Value(double.tryParse(_outTariffController.text ?? '')),
      );

      Provider.of<AppDatabase>(context, listen: false)
          .insertConsumption(entity)
          .then((value) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Odečet byl úspěšně uložen!',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.pushNamed(context, '/');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Přidat odečet')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Zobrazení indikátoru zpracování, pokud probíhá OCR operace.
              if (_isProcessing) const CircularProgressIndicator(),
              // Řádek pro nízký tarif s tlačítkem pro OCR.
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormFieldNotNull(
                      controller: _lowTariffController,
                      txtLabel: "Nízký tarif (kWh)",
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    tooltip: "Skenovat nízký tarif",
                    onPressed: () => _performOCRForField(_lowTariffController),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              // Řádek pro vysoký tarif s tlačítkem pro OCR.
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormFieldNotNull(
                      controller: _highTariffController,
                      txtLabel: "Vysoký tarif (kWh)",
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    tooltip: "Skenovat vysoký tarif",
                    onPressed: () => _performOCRForField(_highTariffController),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              // Řádek pro prodejní tarif s tlačítkem pro OCR.
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormFieldOptional(
                      controller: _outTariffController,
                      txtLabelOptional: "Prodejní tarif (kWh) (volitelný)",
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    tooltip: "Skenovat prodejní tarif",
                    onPressed: () => _performOCRForField(_outTariffController),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: addConsumption,
                child: const Text('Uložit odečet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
