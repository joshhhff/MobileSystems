import 'package:flutter/material.dart';
import 'package:gym_journal_app/Themes/theme.dart';
import 'package:gym_journal_app/Widgets/stopwatch.dart';

class WorkoutControlBar extends StatefulWidget {
  const WorkoutControlBar({super.key});

  @override
  State<WorkoutControlBar> createState() => _WorkoutControlBarState();
}

class _WorkoutControlBarState extends State<WorkoutControlBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Set the background color here
      child: Container(
        margin: const EdgeInsets.all(10.0),
        height: 100,
        decoration: BoxDecoration(
          color: primaryThemeColour,
          borderRadius: BorderRadius.circular(30.0),
          
        ),
        child: Container(
          color: Colors.transparent,
         
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // Timer for workout
                Stopwatch(),
                // LOGS ICON
                Align(
                    alignment: Alignment.centerRight,
                  child: Row(
                    children: [
                        IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 40.0,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    
                  },
                ),
                // ACCOUNT ICON
                IconButton(
                  icon: Icon(
                    Icons.check,
                    size: 40.0,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    
                  },
                ),
                  ],)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}