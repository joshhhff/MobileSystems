class WaterLog {
  String dateCreated;
  double waterAmount;
  String waterUnits;
  String userId;
  String drinkDate;
  String drinkTime;

  WaterLog({
    required this.dateCreated,
    required this.waterAmount,
    required this.waterUnits,
    required this.userId,
    required this.drinkDate,
    required this.drinkTime,
  });

  ToJSON() {
    return {
      'dateCreated': dateCreated,
      'waterAmount': waterAmount,
      'waterUnits': waterUnits,
      'userId': userId,
      'drinkDate': drinkDate,
      'drinkTime': drinkTime,
    };
  }
}