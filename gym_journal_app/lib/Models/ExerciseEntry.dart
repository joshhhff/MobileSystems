import 'package:gym_journal_app/Models/SetEntry.dart';

class ExerciseEntry {
    String name;
    String uniqueKey;
    List<SetEntry>? sets;
    int? exerciseOrder;    // order of exercise in workout
    String? workoutId;    // document id of workout in firestore

    ExerciseEntry({required this.name, required this.uniqueKey, this.sets, this.exerciseOrder, this.workoutId});

    ToJSON() {
        return {
            'name': name,
            'uniqueKey': uniqueKey,
            'exerciseOrder': exerciseOrder,
            'workoutId': workoutId,
        };
    }
}