import 'package:gym_journal_app/Models/ExerciseEntry.dart';

class WorkoutLog {
  String userId;
  String dateCreated;    // ISO date used for sorting
  String workoutDuration;
  String workoutName;
  String exerciseDate;    // user friendly date
  List<ExerciseEntry> exercises;

  WorkoutLog({
    required this.userId,
    required this.dateCreated,
    required this.workoutDuration,
    required this.workoutName,
    required this.exerciseDate,
    required this.exercises,
  });

  ToJSON() {
    return {
      'userId': userId,
      'dateCreated': dateCreated,
      'workoutDuration': workoutDuration,
      'workoutName': workoutName,
      'exerciseDate': exerciseDate,
      'exercises': exercises.map((e) => e.ToJSON()).toList(),
    };
  }
}