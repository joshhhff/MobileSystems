import 'package:flutter/material.dart';
import 'package:gym_journal_app/Services/Database/database_controller.dart';
import 'package:gym_journal_app/Themes/theme.dart';
import 'package:gym_journal_app/Widgets/add_exercise.dart';
import 'package:gym_journal_app/Widgets/appbar.dart';
import 'package:gym_journal_app/Widgets/button_with_icon.dart';
import 'package:gym_journal_app/Widgets/sidebar.dart';
import 'package:gym_journal_app/Widgets/workout_control_bar.dart';

class NewWorkout extends StatefulWidget {
  const NewWorkout({super.key});

  @override
  State<NewWorkout> createState() => _NewWorkoutState();
}

class _NewWorkoutState extends State<NewWorkout> {
	final _scaffoldKey = GlobalKey<ScaffoldState>();

	final _databaseController = DatabaseController();
    final appBarHeight = 55.0;
    final bottomNavBar = 100.0;
    final headerContainerHeight = 110.0;
    final marginsAndPadding = 25.0;
    final marginForLogs = 10.0;
    final sizedBoxSize = 10.0;


  	@override
  	Widget build(BuildContext context) {
    	return Scaffold(
			key: _scaffoldKey,
			appBar: PreferredSize(
				preferredSize: Size.fromHeight(appBarHeight), // Increase AppBar height
				child: MyAppBar(sidebarState: _scaffoldKey, title: 'Workouts'),
			),
			drawer: const SideBar(),
			body: Column(
				children: [
					WorkoutControlBar(),
					AddExercise(),
					
				],
			)
    	);
  	}
}