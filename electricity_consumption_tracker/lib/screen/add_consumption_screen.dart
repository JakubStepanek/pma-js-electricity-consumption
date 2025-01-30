import 'package:electricity_consumption_tracker/database/database.dart';
import 'package:electricity_consumption_tracker/widget/custom_text_form_field_not_null.dart';
import 'package:electricity_consumption_tracker/widget/custom_text_form_field_optional.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:provider/provider.dart';

class AddConsumptionScreen extends StatefulWidget {
  const AddConsumptionScreen({Key? key}) : super(key: key);

  @override
  _AddConsumptionScreenState createState() => _AddConsumptionScreenState();
}

class _AddConsumptionScreenState extends State<AddConsumptionScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _lowTariffController;
  final _highTariffController = TextEditingController();
  final _outTariffController = TextEditingController();

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
                txtLabelOptional: "Prodejní tarif (kWh)",
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  addConsumption();
                },
                child: const Text('Uložit odečet'),
              ),
            ],
          ),
        ),
      ),
    );
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
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                const Expanded(
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
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.pushNamed(context, '/');
      });
    }
  }
}
