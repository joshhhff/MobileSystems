import 'package:flutter/material.dart';
import 'package:gym_journal_app/Scaffolds/Workouts/workouts.dart';
import 'package:gym_journal_app/Themes/theme.dart';
import 'package:gym_journal_app/Widgets/stopwatch.dart';

class WorkoutControlBar extends StatefulWidget {
    final Function(bool, BuildContext) cancelWorkoutCallback; // Callback function
    final Function(bool, int) saveWorkoutCallback; // Callback function
    final BuildContext parentContext;

    const WorkoutControlBar({super.key, required this.cancelWorkoutCallback, required this.saveWorkoutCallback, required this.parentContext});

    @override
    State<WorkoutControlBar> createState() => _WorkoutControlBarState();
}

class _WorkoutControlBarState extends State<WorkoutControlBar> {
    // Define GlobalKey to access StopwatchState
    final GlobalKey<StopwatchState> _stopwatchKey = GlobalKey<StopwatchState>();

    void saveWorkout() {
        // Add your save workout logic here
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text('Save Workout'),
                    content: const Text('Are you sure you want to save the workout? You cannot make changes after saving.'),
                    actions: <Widget>[
                        TextButton(
                            onPressed: () {
                                _stopwatchKey.currentState?.startStopwatch();
                                Navigator.of(context).pop();
                            },
                            child: const Text('No'),
                        ),
                        TextButton(
                            onPressed: () {
                                _stopwatchKey.currentState?.stopStopwatch();
                                int duration = _stopwatchKey.currentState?.getDuration() ?? 0;

                                widget.saveWorkoutCallback(true, duration); // Call the callback function
                                _stopwatchKey.currentState?.dispose();
                            },
                            child: const Text('Yes'),
                        ),
                    ],
                );
            },
        );
    }

    void cancelWorkout() {
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text('Cancel Workout'),
                    content: const Text('Are you sure you want to cancel the workout? Any unsaved data will not be saved.'),
                    actions: <Widget>[
                        TextButton(
                            onPressed: () {
                                Navigator.of(context).pop();
                            },
                            child: const Text('No'),
                        ),
                        TextButton(
                            onPressed: () {
                                _stopwatchKey.currentState?.dispose();
                                widget.cancelWorkoutCallback(true, context); // Call the callback function
                            },
                            child: const Text('Yes'),
                        ),
                    ],
                );
            },
        );
    }

    @override
    Widget build(BuildContext context) {
        return SafeArea(
            child: Container(
                color: Colors.white, // Set the background color here
                child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                        color: primaryThemeColour,
                    ),
                    child: Container(
                        color: Colors.transparent,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                    // Timer for workout
                                    Stopwatch(key: _stopwatchKey),
                                    // cancel icon
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                // cancel icon
                                                Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                        shape: BoxShape.rectangle,
                                                        border: Border.all(color: Colors.white, width: 2.0),
                                                    ),
                                                    child: IconButton(
                                                        icon: Icon(
                                                            Icons.close,
                                                            size: 40.0,
                                                            color: Colors.red,
                                                        ),
                                                        onPressed: () {
                                                            // Add your onPressed code here!
                                                            cancelWorkout();
                                                        },
                                                    ),
                                                ),
                                                const SizedBox(width: 10.0),
                                                // confirm icon
                                                Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                        shape: BoxShape.rectangle,
                                                        border: Border.all(color: Colors.white, width: 2.0),
                                                    ),
                                                    child: IconButton(
                                                        icon: Icon(
                                                            Icons.check,
                                                            size: 40.0,
                                                            color: Colors.green,
                                                        ),
                                                        onPressed: () {
                                                            saveWorkout();
                                                        },
                                                    ),
                                                ),
                                            ],
                                        ),
                                    )
                                ],
                            ),
                        ),
                    ),
                ),
            ),
        );
    }
}