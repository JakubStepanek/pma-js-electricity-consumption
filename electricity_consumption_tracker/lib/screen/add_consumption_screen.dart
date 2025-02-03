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
  final _highTariffController = TextEditingController();
  final _outTariffController = TextEditingController();
  bool _isProcessing = false;

  @override
  void initState() {
    _lowTariffController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _highTariffController.dispose();
    _lowTariffController.dispose();
    _outTariffController.dispose();
    super.dispose();
  }

  /// This method initiates the OCR process.
  /// It captures an image from the camera, extracts text using Tesseract,
  /// and parses numeric values with a regular expression.
  Future<void> _performOCR() async {
    final picker = ImagePicker();
    // Capture image from the camera. Change to ImageSource.gallery if needed.
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return; // User cancelled image picking

    setState(() {
      _isProcessing = true;
    });

    try {
      // Extract text from the image using Tesseract OCR.
      String recognizedText = await FlutterTesseractOcr.extractText(
        pickedFile.path,
        language: 'eng', // Adjust language as needed.
      );

      // Use a regular expression to extract numeric values.
      final RegExp regExp = RegExp(r'\d+(\.\d+)?');
      final matches = regExp.allMatches(recognizedText).toList();

      if (matches.isNotEmpty) {
        // Assign extracted values to controllers.
        // This simple mapping assigns the first number to low tariff,
        // the second to high tariff, and the third (if available) to out tariff.
        if (matches.length >= 1) {
          _lowTariffController.text = matches[0].group(0)!;
        }
        if (matches.length >= 2) {
          _highTariffController.text = matches[1].group(0)!;
        }
        if (matches.length >= 3) {
          _outTariffController.text = matches[2].group(0)!;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nebyl nalezen žádný numerický odečet.')),
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
            shape: RoundedRectangleBorder(
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
              // OCR scanning button
              _isProcessing
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: _performOCR,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Skenovat odečet'),
                    ),
              const SizedBox(height: 16.0),
              CustomTextFormFieldNotNull(
                controller: _lowTariffController,
                txtLabel: "Nízký tarif (kWh)",
              ),
              const SizedBox(height: 16.0),
              CustomTextFormFieldNotNull(
                controller: _highTariffController,
                txtLabel: "Vysoký tarif (kWh)",
              ),
              const SizedBox(height: 16.0),
              CustomTextFormFieldOptional(
                controller: _outTariffController,
                txtLabelOptional: "Prodejní tarif (kWh) (volitelný)",
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
