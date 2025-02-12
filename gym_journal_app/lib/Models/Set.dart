import 'package:gym_journal_app/Models/Exercise.dart';

class Set {
  Exercise exercise;
  String userId;
  int weight;
  String weightUnit;
  int reps;

  Set({
    required this.exercise,
    required this.userId,
    required this.reps,
    required this.weight,
    required this.weightUnit,
  });
}