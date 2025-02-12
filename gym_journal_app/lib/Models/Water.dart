class Water {
  final String amount;
  final String unit;
  final String timestamp;

  Water({required this.amount, required this.unit, required this.timestamp});

  ToJSON() {
    return {
      'amount': amount,
      'unit': unit,
      'timestamp': timestamp,
    };
  }
}