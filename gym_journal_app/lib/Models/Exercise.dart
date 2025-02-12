import 'package:gym_journal_app/Scaffolds/workouts.dart';

class Exercise {
  String excrciseName;
  List<Set> sets;
  Workout workout;

  Exercise({
    required this.excrciseName,
    required this.sets,
    required this.workout,
  });
}