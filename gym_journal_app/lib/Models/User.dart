class UserModel {
  final String userId;  // links to firebase auth user
  final String firstName;
  final String lastName;
  final String email;    // links to firebase auth user
  final String dateCreated;
  final String joinDate;
  final int? waterGoal;
  final String? waterUnits;
  final int? workoutsPerWeek;

  const UserModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dateCreated,
    required this.joinDate,
    this.waterGoal,
    this.waterUnits,
    this.workoutsPerWeek,
  });

  ToJSON() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'dateCreated': dateCreated,
      'joinDate': joinDate,
    };
  }
}