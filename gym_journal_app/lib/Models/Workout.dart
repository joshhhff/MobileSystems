import 'package:gym_journal_app/Models/Exercise.dart';

class WorkoutLog {
  String userId;
  String dateCreated;
  String workoutType;
  String startedAt;
  String endedAt;
  String workoutDuration;
  String workoutName;
  List<Exercise> exercises;

  WorkoutLog({
    required this.userId,
    required this.dateCreated,
    required this.workoutType,
    required this.startedAt,
    required this.endedAt,
    required this.workoutDuration,
    required this.workoutName,
    required this.exercises,
  });
}