import 'package:flutter/material.dart';
import '../models/electricity_database.dart';

class AddConsumptionScreen extends StatefulWidget {
  @override
  _AddConsumptionScreenState createState() => _AddConsumptionScreenState();
}

class _AddConsumptionScreenState extends State<AddConsumptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _lowController = TextEditingController();
  final _highController = TextEditingController();
  final _outController = TextEditingController();

  final ElectricityDatabase db = ElectricityDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Consumption')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _lowController,
                decoration:
                    InputDecoration(labelText: 'Low Tarif Consumption (kWh)'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter low tarif consumption'
                    : null,
              ),
              TextFormField(
                controller: _highController,
                decoration:
                    InputDecoration(labelText: 'High Tarif Consumption (kWh)'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter high tarif consumption'
                    : null,
              ),
              TextFormField(
                controller: _outController,
                decoration:
                    InputDecoration(labelText: 'Export to Grid (Optional)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    db.insertConsumption(ElectricityConsumptionEntry(
                      date: DateTime.now(),
                      consumptionTarifLow: double.parse(_lowController.text),
                      consumptionTarifHigh: double.parse(_highController.text),
                      consumptionTarifOut: _outController.text.isEmpty
                          ? null
                          : double.parse(_outController.text),
                    ));
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Consumption'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
