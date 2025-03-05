import 'package:flutter/material.dart';
import 'package:gym_journal_app/Themes/theme.dart';
import 'package:gym_journal_app/Widgets/button_with_icon.dart';

class AddExercise extends StatefulWidget {
  const AddExercise({super.key});

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
      onClick: () {
        // add logic to add new excercise to page
      } );
  }
}