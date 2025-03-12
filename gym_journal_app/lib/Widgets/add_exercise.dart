import 'package:flutter/material.dart';
import 'package:gym_journal_app/Themes/theme.dart';
import 'package:gym_journal_app/Widgets/button_with_icon.dart';
import 'package:gym_journal_app/Widgets/exercise_list.dart';

class AddExercise extends StatefulWidget {
  final Function(Map<String, dynamic>) onExerciseSelected; // Callback function

  const AddExercise({super.key, required this.onExerciseSelected});

  @override
  State<AddExercise> createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  @override
  Widget build(BuildContext context) {
    return ButtonWithIcon(
      text: 'Exercise',
      icon: Icons.add,
      textColour: Colors.white,
      colour: primaryThemeColour,
      onClick: () async {
        final selectedExercise = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ExerciseList()),
        );

        if (selectedExercise != null) {
          widget.onExerciseSelected(selectedExercise); // Pass data up to NewWorkout
        }
      },
    );
  }
}
