import 'package:flutter/material.dart';
import 'package:gym_journal_app/Scaffolds/Workouts/new_workout.dart';
import 'package:gym_journal_app/Themes/theme.dart';
import 'package:gym_journal_app/Widgets/button_with_icon.dart';

class WorkoutInfoHeader extends StatelessWidget {
    final double marginsAndPadding;
    final double sizedBoxSize;
    final String exerciseName;

    const WorkoutInfoHeader({super.key, required this.marginsAndPadding, required this.sizedBoxSize, required this.exerciseName});

    @override
    Widget build(BuildContext context) {
        return Container(
            margin: EdgeInsets.all(marginsAndPadding),
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    Text(
                        exerciseName,
                        style: TextStyle(
                            color: primaryThemeColour,
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                        ),
                    ),
                    SizedBox(height: sizedBoxSize),
                    // Add more content here
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          // add logic for deleting/copying workout
                        },
                        child: Icon(
                            Icons.more_vert,
                            size: 40,
                            color: const Color.fromARGB(255, 75, 73, 73),
                        ),
                      ),
                    ),
                ],
            ),
        );
    }
}