import 'package:flutter/material.dart';

class AddConsumptionScreen extends StatefulWidget {
  @override
  _AddConsumptionScreenState createState() => _AddConsumptionScreenState();
}

class _AddConsumptionScreenState extends State<AddConsumptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _lowTariffController = TextEditingController();
  final _highTariffController = TextEditingController();
  final _outTariffController = TextEditingController();

  // void _saveConsumption() async {
  //   if (_formKey.currentState!.validate()) {
  //     final newConsumption = ConsumptionsCompanion(
  //       date: drift.Value(DateTime.now()),
  //       consumptionTarifLow:
  //           drift.Value(double.parse(_lowTariffController.text)),
  //       consumptionTarifHigh:
  //           drift.Value(double.parse(_highTariffController.text)),
  //       consumptionTarifOut:
  //           drift.Value(double.parse(_outTariffController.text)),
  //     );

  //     await widget.db.databaseHelper.insertConsumption(newConsumption);
  //     Navigator.pop(context); // Návrat na předchozí obrazovku po uložení
  //   }
  // }

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
              TextFormField(
                controller: _lowTariffController,
                decoration: InputDecoration(labelText: 'Nízký tarif (kWh)'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty
                    ? 'Zadejte, prosím, nízký tarif.'
                    : null,
              ),
              TextFormField(
                controller: _highTariffController,
                decoration: InputDecoration(labelText: 'Vysoký tarif (kWh)'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty
                    ? 'Zadejte, prosím, vysoký tarif.'
                    : null,
              ),
              TextFormField(
                controller: _outTariffController,
                decoration: InputDecoration(labelText: 'Prodejní tarif (kWh)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                //onPressed: _saveConsumption,
                onPressed: () => {},
                child: Text('Uložit odečet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
