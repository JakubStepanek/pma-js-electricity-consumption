import 'package:electricity_consumption_tracker/database/database.dart';
import 'package:electricity_consumption_tracker/widget/custom_app_bar.dart';
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

/// This Dart class represents the state for an "AddConsumptionScreen" widget with form key, text
/// editing controllers for low, high, and out tariffs, and a processing flag.
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

  /// The function `_performOCRForField` captures an image using the device's camera, performs OCR to
  /// extract text, extracts numeric values from the recognized text, and updates a text field with the
  /// extracted value or displays a message if no numeric value is found.
  ///
  /// Args:
  ///   controller (TextEditingController): The `controller` parameter in the `_performOCRForField`
  /// function is of type `TextEditingController`. This controller is typically used to control the text
  /// and selection in an editable text field, such as a TextField widget in Flutter. In this function,
  /// the recognized text extracted from the image using OCR will
  ///
  /// Returns:
  ///   The `_performOCRForField` function returns a `Future<void>`.
  Future<void> _performOCRForField(TextEditingController controller) async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      String recognizedText = await FlutterTesseractOcr.extractText(
        pickedFile.path,
        language: 'eng',
      );

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

  /// The `addConsumption` function validates form input and inserts consumption data into a database,
  /// showing a success message and navigating to the home screen upon completion.
  ///
  /// Returns:
  ///   The `addConsumption` function is returning a `void` type, which means it does not return any
  /// value. It performs the necessary operations to add a consumption entry to the database and show a
  /// success message in a SnackBar.
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

  /// The build function returns a Scaffold widget with an app bar, form fields for entering different
  /// tariff values, buttons for scanning values using OCR, and a button to save the consumption data.
  ///
  /// Args:
  ///   context (BuildContext): The `context` parameter in the `build` method of a Flutter widget
  /// represents the location of the widget within the widget tree. It provides access to various
  /// properties and methods related to the widget's location and configuration in the UI hierarchy.
  ///
  /// Returns:
  ///   The build method in the provided code snippet is returning a Scaffold widget. The Scaffold
  /// widget is a top-level container for a Material Design layout and provides a structure for the
  /// visual elements of a screen, such as an app bar, body content, and bottom navigation.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Přidat odečet'),
        flexibleSpace: GradientAppBar(),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_isProcessing) const CircularProgressIndicator(),
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
