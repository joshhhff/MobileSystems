import 'package:flutter/material.dart';
import 'package:gym_journal_app/Scaffolds/Workouts/new_workout.dart';
import 'package:gym_journal_app/Themes/theme.dart';
import 'package:gym_journal_app/Widgets/button_with_icon.dart';

class WorkoutsHeader extends StatelessWidget {
    final double marginsAndPadding;
    final double headerContainerHeight;
    final double sizedBoxSize;
    const WorkoutsHeader({super.key, required this.marginsAndPadding, required this.headerContainerHeight, required this.sizedBoxSize});

    @override
    Widget build(BuildContext context) {
        return Container(
            margin: EdgeInsets.all(marginsAndPadding),
            height: headerContainerHeight,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    Text(
                        'Exercise Logs',
                        style: TextStyle(
                            color: primaryThemeColour,
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                        ),
                    ),
                    SizedBox(height: sizedBoxSize),
                    ButtonWithIcon(
                        text: 'Start Workout',
                        icon: Icons.add,
                        textColour: Colors.white,
                        colour: primaryThemeColour,
                        onClick: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const NewWorkout()),
                            );
                        },
                    ),
                    // Add more content here
                ],
            ),
        );
    }
}
