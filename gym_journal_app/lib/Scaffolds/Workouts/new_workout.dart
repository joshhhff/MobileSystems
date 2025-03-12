import 'package:flutter/material.dart';
import 'package:gym_journal_app/Models/ExerciseEntry.dart';
import 'package:gym_journal_app/Models/SetEntry.dart';
import 'package:gym_journal_app/Models/WorkoutLog.dart';
import 'package:gym_journal_app/Scaffolds/Workouts/workouts.dart';
import 'package:gym_journal_app/Services/Authentication/Controllers/AuthenticationServices.dart';
import 'package:gym_journal_app/Services/Database/database_controller.dart';
import 'package:gym_journal_app/Themes/theme.dart';
import 'package:gym_journal_app/Utilities/common_tools.dart';
import 'package:gym_journal_app/Widgets/add_exercise.dart';
import 'package:gym_journal_app/Widgets/bottom_nav_bar.dart';
import 'package:gym_journal_app/Widgets/countdown.dart';
import 'package:gym_journal_app/Widgets/new_excercise.dart';
import 'package:gym_journal_app/Widgets/sidebar.dart';
import 'package:gym_journal_app/Widgets/workout_control_bar.dart';

class NewWorkout extends StatefulWidget {
    const NewWorkout({super.key});

    @override
    State<NewWorkout> createState() => _NewWorkoutState();
}

class _NewWorkoutState extends State<NewWorkout> {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    final _authController = AuthenticationController();
    final _toolsController = CommonTools();
    final _databaseController = DatabaseController();
    final _utilitiesController = CommonTools();
    String? selectedExerciseName; // Store selected exercise name
    List<ExerciseEntry> exercises = [];
    final _workoutNameController = TextEditingController();

    void addExercise(Map<String, dynamic> exercise) {
        setState(() {
            exercises.add(
                ExerciseEntry(
                    name: exercise['name'], 
                    uniqueKey: _utilitiesController.createUniqueID()
                )
            );
        });
    }

    void updateExercise(String workout, List<SetEntry> sets) {
        setState(() {
            final index = exercises.indexWhere((element) => element.uniqueKey == workout);
            if (index != -1) {
                exercises[index].sets = sets;
                print('updated exercise ${exercises[index].sets}');
            }
        });
    }

    void removeExercise(String uniqueKey) {
        setState(() {
            final index = exercises.indexWhere((element) => element.uniqueKey == uniqueKey);
            if (index != -1) {
                exercises.removeAt(index);
            }
        });
    }

    void cancelWorkout(bool cancel, BuildContext context) {
        if (cancel) {
            exercises.clear();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Workout())
            );
        }
    }

    void saveWorkout(bool save, int duration) async {

        var user = await _authController.getCurrentUser();
        var userId = user!.uid;  // retrieve doc id for update

        WorkoutLog newWorkout = WorkoutLog(
            userId: userId,
            dateCreated: _toolsController.getTimestamp(),
            workoutDuration: _toolsController.formatTime(duration),
            workoutName: _workoutNameController.text,
            exerciseDate: _toolsController.getFormattedDate(),
            exercises: exercises,
        );

        var createNewWorkout = await _databaseController.logNewWorkout(newWorkout);

        if (createNewWorkout.success) {
            exercises.clear();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Workout())
            );
        } else {
          // show error message
            /* _scaffoldKey.currentState!.showSnackBar(
                SnackBar(
                    content: Text('Error logging workout: ${createNewWorkout.message}'),
                    duration: const Duration(seconds: 2),
                ),
            ); */
        }
    }

    @override
    Widget build(BuildContext context) {
        final screen = MediaQuery.sizeOf(context);

        return Scaffold(
            key: _scaffoldKey,
            backgroundColor: primaryThemeColour,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(100),
                child: WorkoutControlBar(
                    cancelWorkoutCallback: cancelWorkout, // Pass function down
                    saveWorkoutCallback: saveWorkout, // Pass function down
                    parentContext: context,
                ),
            ),
            drawer: const SideBar(),
            body: LayoutBuilder(
                builder: (context, constraints) {
                    return SingleChildScrollView(
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                            ),
                            child: IntrinsicHeight(
                                child: Column(
                                    children: [
                                        Expanded(
                                            child: Container(
                                                width: screen.width,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.only(
                                                        topRight: Radius.circular(50.0),
                                                    ),
                                                ),
                                                child: Padding(
                                                    padding: const EdgeInsets.all(20.0),
                                                    child: Column(
                                                        children: [
                                                            Focus(
                                                                autofocus: false,
                                                                child: TextField(
                                                                    controller: _workoutNameController,
                                                                    decoration: InputDecoration(
                                                                        labelText: 'Workout Name',
                                                                        border: UnderlineInputBorder(),
                                                                    ),
                                                                    /* onChanged: (text) {
                                                                        setState(() {
                                                                            _workoutNameController = text;
                                                                        });
                                                                    }, */
                                                                ),
                                                            ),
                                                            SizedBox(height: 20),
                                                            ...exercises.asMap().entries.map((entry) {
                                                                ExerciseEntry exercise = entry.value;

                                                                return NewExcercise(
                                                                    exerciseName: exercise.name,
                                                                    onDismiss: removeExercise,
                                                                    onSetChange: updateExercise,
                                                                    uniqueKey: exercise.uniqueKey,
                                                                );
                                                            }).toList(),
                                                            Row(
                                                                mainAxisAlignment:
                                                                        MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                    Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: AddExercise(
                                                                            onExerciseSelected: addExercise, // Pass function down
                                                                        ),
                                                                    ),
                                                                    Align(
                                                                        alignment: Alignment.centerRight,
                                                                        child: Countdown(),
                                                                    ),
                                                                ],
                                                            )
                                                        ],
                                                    ),
                                                ),
                                            ),
                                        ),
                                    ],
                                ),
                            ),
                        ),
                    );
                },
            ),
        );
    }
}
