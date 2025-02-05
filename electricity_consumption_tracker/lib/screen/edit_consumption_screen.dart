import 'package:electricity_consumption_tracker/database/database.dart';
import 'package:electricity_consumption_tracker/widget/custom_app_bar.dart';
import 'package:electricity_consumption_tracker/widget/custom_text_form_field_not_null.dart';
import 'package:electricity_consumption_tracker/widget/custom_text_form_field_optional.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EditConsumptionScreen extends StatefulWidget {
  final int id;
  const EditConsumptionScreen({required this.id, Key? key}) : super(key: key);

  @override
  _EditConsumptionScreenState createState() => _EditConsumptionScreenState();
}

class _EditConsumptionScreenState extends State<EditConsumptionScreen> {
  late Consumption _consumption;
  final _formKey = GlobalKey<FormState>();
  final _lowTariffController = TextEditingController();
  final _highTariffController = TextEditingController();
  final _outTariffController = TextEditingController();
  final _dateController = TextEditingController();

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
    _dateController.dispose();
    super.dispose();
  }

  @override

  /// This function builds a form for editing consumption data with fields for date, low tariff, high
  /// tariff, and optional selling tariff, along with a button to save the data.
  ///
  /// Args:
  ///   context (BuildContext): The `context` parameter in Flutter represents the build context of the
  /// widget. It is a reference to the location of a widget within the widget tree. The context
  /// parameter is typically used to access theme data, media queries, navigator, and other information
  /// related to the widget's placement in the widget tree.
  ///
  /// Returns:
  ///   The `build` method is returning a `Scaffold` widget with an `AppBar` and a `body` containing a
  /// `Padding` widget with a `Form` widget as its child. Inside the `Form`, there is a `Column` widget
  /// with several child widgets including `GestureDetector`, `CustomTextFormFieldNotNull`,
  /// `CustomTextFormFieldOptional`, `SizedBox`, and an `
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upravit odečet'),
        flexibleSpace: GradientAppBar(),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Datum odečtu',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Prosím vyberte datum';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              CustomTextFormFieldNotNull(
                  controller: _lowTariffController,
                  txtLabel: "Nízký tarif (kWh)"),
              const SizedBox(height: 16.0),
              CustomTextFormFieldNotNull(
                  controller: _highTariffController,
                  txtLabel: "Vysoký tarif (kWh)"),
              const SizedBox(height: 16.0),
              CustomTextFormFieldOptional(
                  controller: _outTariffController,
                  txtLabelOptional: "Prodejní tarif (kWh)"),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  editConsumption();
                },
                child: const Text('Uložit odečet'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The `_selectDate` function allows the user to pick a date and updates the `_consumption` object with
  /// the selected date and time set to 12:00 PM.
  ///
  /// Args:
  ///   context (BuildContext): The `context` parameter in the `_selectDate` function is a reference to
  /// the BuildContext of the widget that is calling the function. It is typically used to show dialogs,
  /// navigate to different screens, access theme data, and more within the Flutter framework. In this
  /// case, it is being passed
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _consumption.date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _consumption.date) {
      // Create a new DateTime object with the desired time (12:00 PM)
      final DateTime pickedWithTime = DateTime(
        picked.year,
        picked.month,
        picked.day,
        12, // Hour set to 12
        0, // Minute set to 0
      );

      setState(() {
        _consumption = _consumption.copyWith(date: pickedWithTime);
        _dateController.text = DateFormat('dd.MM.yyyy').format(pickedWithTime);
      });
    }
  }

  /// The `editConsumption` function updates consumption data in a database and displays a success
  /// message in a SnackBar.
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
            drift.Value(double.tryParse(_outTariffController.text ?? '')),
      );

      Provider.of<AppDatabase>(context, listen: false)
          .updateConsumption(entity)
          .then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(
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
            ),
          );
    }
    Navigator.pushNamed(context, '/consumption_list');
  }

  /// This Dart function retrieves consumption data from a database and updates text controllers with
  /// the retrieved values.
  Future<void> getConsumption() async {
    _consumption = await Provider.of<AppDatabase>(context, listen: false)
        .getConsumption(widget.id);
    _highTariffController.text = _consumption.consumptionTarifHigh.toString();
    _lowTariffController.text = _consumption.consumptionTarifLow.toString();
    _outTariffController.text =
        _consumption.consumptionTarifOut?.toString() ?? '';
    _dateController.text = DateFormat('dd.MM.yyyy').format(_consumption.date);
  }
}
