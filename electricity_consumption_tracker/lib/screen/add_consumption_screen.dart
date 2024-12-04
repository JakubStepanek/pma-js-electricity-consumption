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
  final _lowTariffController = TextEditingController();
  final _highTariffController = TextEditingController();
  final _outTariffController = TextEditingController();

  @override
  void initState() {
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
      appBar: AppBar(title: Text('Přidat odečet')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormFieldNotNull(
                  controller: _lowTariffController,
                  txtLabel: "Nízků tarif (kWh)"),
              const SizedBox(height: 16.0),
              CustomTextFormFieldNotNull(
                  controller: _highTariffController,
                  txtLabel: "Vysoký tarif (kWh)"),
              const SizedBox(height: 16.0),
              CustomTextFormFieldOptional(
                  controller: _outTariffController,
                  txtLabelOptional: "Prodejní tarif (kWh)"),
              SizedBox(height: 16),
              ElevatedButton(
                //onPressed: _saveConsumption,
                onPressed: () {
                  addConsumption();
                },
                child: Text('Uložit odečet'),
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
          .then(
            (value) => ScaffoldMessenger.of(context).showMaterialBanner(
              MaterialBanner(
                backgroundColor: const Color.fromARGB(255, 5, 134, 72),
                content: Text(
                  'Odečet uložen: $value',
                  style: const TextStyle(color: Colors.white),
                ),
                actions: [
                  TextButton(
                    onPressed: () => ScaffoldMessenger.of(context)
                        .hideCurrentMaterialBanner(),
                    child: const Text(
                      'Zavřít',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          );
    }
  }
}
