import 'package:flutter/material.dart';
import 'package:gym_journal_app/Models/Result.dart';
import 'package:gym_journal_app/Services/Database/database_controller.dart';
import 'package:gym_journal_app/Themes/theme.dart';
import 'package:gym_journal_app/Utilities/common_tools.dart';
import 'package:gym_journal_app/Widgets/appbar.dart';
import 'package:gym_journal_app/Widgets/bottom_nav_bar.dart';
import 'package:gym_journal_app/Widgets/sidebar.dart';
import 'package:gym_journal_app/Widgets/workout_info_header.dart';

class WorkoutInfo extends StatefulWidget {
  final String workoutId;
  final String workoutName;

  const WorkoutInfo({super.key, required this.workoutId, required this.workoutName});

  @override
  State<WorkoutInfo> createState() => _WorkoutInfoState();
}

class _WorkoutInfoState extends State<WorkoutInfo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _databaseController = DatabaseController();
  final _utilities = CommonTools();

  final appBarHeight = 55.0;
  final bottomNavBar = 100.0;
  final marginsAndPadding = 25.0;
  final sizedBoxSize = 10.0;

  Future<Result> getWorkoutData() async {
    try {
      var exercises = await _databaseController.getWorkoutData(widget.workoutId);
      return Result(success: true, message: '', data: exercises);
    } catch (e) {
      return Result(success: false, message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getWorkoutData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              color: primaryThemeColour,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          if (snapshot.hasData) {
            final result = snapshot.data as Result;
            if (result.success) {
              final exerciseLogs = result.data.data;

              return Scaffold(
                key: _scaffoldKey,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(appBarHeight),
                  child: MyAppBar(sidebarState: _scaffoldKey, title: 'Workouts'),
                ),
                drawer: const SideBar(),
                body: Column(
                  children: <Widget>[
                    WorkoutInfoHeader(
                      marginsAndPadding: marginsAndPadding,
                      sizedBoxSize: sizedBoxSize,
                      exerciseName: widget.workoutName,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryThemeColour,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(marginsAndPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Exercises',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: sizedBoxSize),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: exerciseLogs.length,
                                  itemBuilder: (context, index) {
                                    final log = exerciseLogs[index];
                                    final sets = log['sets'] ?? [];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                                            child: Text(
                                              log['name'] ?? 'Unknown Exercise',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: primaryThemeColour,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Column(
                                            children: List.generate(sets.length, (setIndex) {
                                              final set = sets[setIndex];
                                              return Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    top: BorderSide(color: primaryThemeColour.withOpacity(0.3), width: 0.5),
                                                    bottom: BorderSide(color: primaryThemeColour.withOpacity(0.3), width: 0.5),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          left: BorderSide(
                                                            color: Colors.transparent,
                                                            width: 10,
                                                          ),
                                                          right: BorderSide(color: primaryThemeColour.withOpacity(0.3), width: 0.5),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '${setIndex + 1}',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                            color: primaryThemeColour,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                     Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            width: 100, // Set the desired width here
                                                            child: Text(
                                                              '${set['weight']}kg',
                                                              style: TextStyle(color: primaryThemeColour),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 20),
                                                          Text(
                                                            '${set['reps']} reps',
                                                            style: TextStyle(color: primaryThemeColour),
                                                          ),
                                                        ],
                                                      ),
                                                  ],
                                                ),
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: const BottomNavBar(page: 'exercise'),
              );
            } else {
              return Text('No data');
            }
          } else {
            return Text('No data');
          }
        }
      },
    );
  }
}
