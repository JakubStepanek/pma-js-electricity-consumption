class ElectricityConsumption {
  final DateTime date;
  final double consumptionTarifLow;
  final double consumptionTarifHigh;
  final double? consumptionTarifOut;

  ElectricityConsumption({
    required this.date,
    required this.consumptionTarifLow,
    required this.consumptionTarifHigh,
    this.consumptionTarifOut,
  });
}
