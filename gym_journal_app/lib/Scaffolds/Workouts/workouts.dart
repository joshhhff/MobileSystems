import 'package:flutter/material.dart';
import 'package:gym_journal_app/Models/Result.dart';
import 'package:gym_journal_app/Models/WorkoutLog.dart';
import 'package:gym_journal_app/Scaffolds/Workouts/new_workout.dart';
import 'package:gym_journal_app/Scaffolds/Popups/quick_entries.dart';
import 'package:gym_journal_app/Scaffolds/Workouts/workout_info.dart';
import 'package:gym_journal_app/Services/Database/database_controller.dart';
import 'package:gym_journal_app/Themes/theme.dart';
import 'package:gym_journal_app/Utilities/common_tools.dart';
import 'package:gym_journal_app/Widgets/appbar.dart';
import 'package:gym_journal_app/Widgets/bottom_nav_bar.dart';
import 'package:gym_journal_app/Widgets/button_with_icon.dart';
import 'package:gym_journal_app/Widgets/sidebar.dart';
import 'package:gym_journal_app/Widgets/workouts_header.dart';

class Workout extends StatefulWidget {
    const Workout({super.key});

    @override
    State<Workout> createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final _databaseController = DatabaseController();
    final _utilities = CommonTools();

    final appBarHeight = 55.0;
    final bottomNavBar = 100.0;
    final headerContainerHeight = 110.0;
    final marginsAndPadding = 25.0;
    final marginForLogs = 10.0;
    final sizedBoxSize = 10.0;

    Future<Result> fetchAllData() async {
        try {

            Result workouts = await _databaseController.RetrieveCollection('entries', 'workouts');

            if (workouts.success) {
                var snapshot = workouts.data;
                var workoutsData = snapshot.docs.map((doc) {
                    var data = doc.data();
                    data['id'] = doc.id; // Add document ID to the data
                    return data;
                }).toList();
                workoutsData.sort((a, b) => DateTime.parse(b['dateCreated']).compareTo(DateTime.parse(a['dateCreated'])));

                return Result(success: true, message: '', data: workoutsData);
            } else {
                return Result(success: false, message: workouts.message);
            }
        } catch (e) {
            return Result(success: false, message: 'Error fetching data');
        }
    }

    void showModal(BuildContext context) {
        showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
                return QuickEntries(refreshWaterPage: true, refreshWorkoutPage: true);
            },
        );
    }

    @override
    Widget build(BuildContext context) {
        return FutureBuilder(
            future: fetchAllData(),
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
                            // select all exercise logs
                            final exerciseLogs = result.data;
                            print('exercise logs $exerciseLogs');
                            final screen = MediaQuery.sizeOf(context);

                            final remainingHeight = (screen.height) -
                                    appBarHeight -
                                    headerContainerHeight -
                                    bottomNavBar;

                            return Scaffold(
                                key: _scaffoldKey,
                                appBar: PreferredSize(
                                    preferredSize: Size.fromHeight(appBarHeight), // Increase AppBar height
                                    child: MyAppBar(sidebarState: _scaffoldKey, title: 'Workouts'),
                                ),
                                drawer: const SideBar(),
                                body: Column(
                                    children: <Widget>[
                                        WorkoutsHeader(
                                            marginsAndPadding: marginsAndPadding,
                                            headerContainerHeight: headerContainerHeight,
                                            sizedBoxSize: sizedBoxSize,
                                        ),
                                        Expanded(
                                            child: LayoutBuilder(
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
                                                                                //height: MediaQuery.of(context).size.height - boxheight - 60, // Adjust the height as needed
                                                                                decoration: BoxDecoration(
                                                                                    color: primaryThemeColour,
                                                                                    borderRadius: BorderRadius.only(
                                                                                        topLeft: Radius.circular(50.0),
                                                                                    ),
                                                                                ),
                                                                                child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                        Container(
                                                                                            padding: EdgeInsets.only(top: marginsAndPadding),
                                                                                            child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                children: [
                                                                                                    Align(
                                                                                                        alignment: Alignment.centerLeft,
                                                                                                        child: Padding(
                                                                                                            padding: EdgeInsets.only(left: marginsAndPadding),
                                                                                                            child: Text(
                                                                                                                'Previous logs',
                                                                                                                style: TextStyle(
                                                                                                                    fontSize: 24,
                                                                                                                    fontWeight: FontWeight.bold,
                                                                                                                    color: Colors.white,
                                                                                                                ),
                                                                                                            ),
                                                                                                        ),
                                                                                                    ),
                                                                                                    SizedBox(height: sizedBoxSize),
                                                                                                    if (exerciseLogs.isEmpty)
                                                                                                        Center(
                                                                                                            heightFactor: 2.0,
                                                                                                            child: Column(
                                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                children: [
                                                                                                                    Text(
                                                                                                                        'No workouts logged yet!',
                                                                                                                        style: TextStyle(
                                                                                                                            color: Colors.white,
                                                                                                                            fontSize: 20,
                                                                                                                            fontWeight: FontWeight.bold,
                                                                                                                        ),
                                                                                                                    ),
                                                                                                                    SizedBox(height: sizedBoxSize),
                                                                                                                    ButtonWithIcon(
                                                                                                                        text: 'Start Workout',
                                                                                                                        icon: Icons.add,
                                                                                                                        textColour: primaryThemeColour,
                                                                                                                        colour: Colors.white,
                                                                                                                        onClick: () {
                                                                                                                            showModal(context);
                                                                                                                        },
                                                                                                                    ),
                                                                                                                ],
                                                                                                            ),
                                                                                                        ),
                                                                                                    if (!exerciseLogs.isEmpty)
                                                                                                        Container(
                                                                                                            padding: EdgeInsets.only(
                                                                                                                left: marginsAndPadding,
                                                                                                                right: marginsAndPadding
                                                                                                            ),
                                                                                                            height: constraints.maxHeight - 80,
                                                                                                            child: ListView.builder(
                                                                                                                itemCount: exerciseLogs.length,
                                                                                                                itemBuilder: (context, index) {
                                                                                                                    final element = exerciseLogs[index];

                                                                                                                    return GestureDetector(
                                                                                                                        onTap: () {
                                                                                                                            Navigator.push(
                                                                                                                                context,
                                                                                                                                MaterialPageRoute(
                                                                                                                                    builder: (context) => WorkoutInfo(
                                                                                                                                        workoutId: element['id'],
                                                                                                                                        workoutName: element['workoutName'],
                                                                                                                                    ),
                                                                                                                                ),
                                                                                                                            );
                                                                                                                        },
                                                                                                                        child: Container(
                                                                                                                            width: double.infinity,
                                                                                                                            margin: EdgeInsets.only(bottom: marginForLogs),
                                                                                                                            padding: const EdgeInsets.all(10.0),
                                                                                                                            decoration: BoxDecoration(
                                                                                                                                color: Colors.white,
                                                                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                                                                                boxShadow: [
                                                                                                                                    BoxShadow(
                                                                                                                                        color: Colors.grey.withOpacity(0.5),
                                                                                                                                        spreadRadius: 5,
                                                                                                                                        blurRadius: 7,
                                                                                                                                        offset: Offset(0, 3),
                                                                                                                                    ),
                                                                                                                                ],
                                                                                                                            ),
                                                                                                                            child: Row(
                                                                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                                                children: [
                                                                                                                                    Expanded(
                                                                                                                                        child: Column(
                                                                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                            children: [
                                                                                                                                                Text(element['workoutName'],
                                                                                                                                                    style: TextStyle(
                                                                                                                                                        fontSize: 16,
                                                                                                                                                        fontWeight: FontWeight.bold
                                                                                                                                                    )
                                                                                                                                                ),
                                                                                                                                                SizedBox(height: 5),
                                                                                                                                                Text('Date: ${element['exerciseDate']}',
                                                                                                                                                    style: TextStyle(
                                                                                                                                                        fontSize: 14, 
                                                                                                                                                        color: Colors.grey
                                                                                                                                                    )
                                                                                                                                                ),
                                                                                                                                                SizedBox(height: 5),
                                                                                                                                                Text('Duration: ${element['workoutDuration']}',
                                                                                                                                                    style: TextStyle(
                                                                                                                                                        fontSize: 14, 
                                                                                                                                                        color: Colors.grey
                                                                                                                                                    )
                                                                                                                                                ),
                                                                                                                                            ],
                                                                                                                                        ),
                                                                                                                                    ),
                                                                                                                                   
                                                                                                                                ],
                                                                                                                            ),
                                                                                                                        ),
                                                                                                                    );
                                                                                                                },
                                                                                                            ),
                                                                                                        ),
                                                                                                ],
                                                                                            ),
                                                                                        ),
                                                                                    ],
                                                                                ),
                                                                            ),
                                                                        )
                                                                    ],
                                                                ),
                                                            ),
                                                        ),
                                                    );
                                                },
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