import 'package:electricity_consumption_tracker/database/database.dart';
import 'package:electricity_consumption_tracker/widget/custom_text_form_field_not_null.dart';
import 'package:electricity_consumption_tracker/widget/custom_text_form_field_optional.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:provider/provider.dart';

class EditConsumptionScreen extends StatefulWidget {
  final int id;
  const EditConsumptionScreen({required this.id, key}) : super(key: key);

  @override
  _EditConsumptionScreenState createState() => _EditConsumptionScreenState();
}

class _EditConsumptionScreenState extends State<EditConsumptionScreen> {
  late Consumption _consumption;
  final _formKey = GlobalKey<FormState>();
  final _lowTariffController = TextEditingController();
  final _highTariffController = TextEditingController();
  final _outTariffController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getConsumption();
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
      appBar: AppBar(title: Text('Upravit odečet')),
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
                  editConsumption();
                },
                child: Text('Uložit odečet'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void editConsumption() {
    final isValid = _formKey.currentState?.validate();

    if (isValid != null && isValid) {
      final entity = ConsumptionsCompanion(
        id: drift.Value(widget.id),
        date: drift.Value(_consumption.date),
        consumptionTarifHigh:
            drift.Value(double.parse(_highTariffController.text)),
        consumptionTarifLow:
            drift.Value(double.parse(_lowTariffController.text)),
        consumptionTarifOut:
            drift.Value(double.parse(_outTariffController.text)),
      );

      Provider.of<AppDatabase>(context, listen: false)
          .updateConsumption(entity)
          .then(
            (value) => ScaffoldMessenger.of(context).showMaterialBanner(
              MaterialBanner(
                backgroundColor: const Color.fromARGB(255, 5, 134, 72),
                content: Text(
                  'Odečet aktualizován!',
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

  Future<void> getConsumption() async {
    _consumption =
        await Provider.of<AppDatabase>(context, listen: false).getConsumption(widget.id);
    _highTariffController.text = _consumption.consumptionTarifHigh.toString();
    _lowTariffController.text = _consumption.consumptionTarifLow.toString();
    _outTariffController.text = _consumption.consumptionTarifOut.toString();
  }
}
