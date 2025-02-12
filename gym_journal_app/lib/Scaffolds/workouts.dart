import 'package:flutter/material.dart';
import 'package:gym_journal_app/Models/Result.dart';
import 'package:gym_journal_app/Scaffolds/Popups/quick_entries.dart';
import 'package:gym_journal_app/Services/Database/database_controller.dart';
import 'package:gym_journal_app/Themes/theme.dart';
import 'package:gym_journal_app/Widgets/appbar.dart';
import 'package:gym_journal_app/Widgets/bottom_nav_bar.dart';
import 'package:gym_journal_app/Widgets/button_with_icon.dart';
import 'package:gym_journal_app/Widgets/sidebar.dart';

class Workout extends StatefulWidget {
  const Workout({super.key});

  @override
  State<Workout> createState() => _WorkoutState();

}

class _WorkoutState extends State<Workout> {
	final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final _databaseController = DatabaseController();

    final appBarHeight = 55.0;
    final bottomNavBar = 100.0;
    final headerContainerHeight = 110.0;
    final marginsAndPadding = 25.0;
    final sizedBoxSize = 10.0;
    
    Future<Result> fetchAllData() async {
        try {

            return Result(success: true, message: '', data: [{'test': 'test'}]);
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
                            // select all water logs
                            final data = result.data[0];

                            final remainingHeight = (MediaQuery.sizeOf(context).height) - appBarHeight - bottomNavBar - headerContainerHeight + (marginsAndPadding * 3) + (sizedBoxSize * 2);

                            return Scaffold(
                                key: _scaffoldKey,
                                appBar: PreferredSize(
                                    preferredSize: Size.fromHeight(appBarHeight), // Increase AppBar height
                                    child: MyAppBar(sidebarState: _scaffoldKey, title: 'Workouts'),
                                ),
                                drawer: const SideBar(),
                                body: Column(
                                children: <Widget>[
                                    Container(
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
                                                    'Workouts',
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
                                                    onClick: () { showModal(context); },
                                                ),
                                                // Add more content here
                                            ],
                                        ),
                                    ),
                                    Container(
                                        //height: MediaQuery.of(context).size.height - boxheight - 60, // Adjust the height as needed
                                        decoration: BoxDecoration(
                                            color: primaryThemeColour,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(50.0),
                                            ),
                                        ),
                                        child: Column(
                                            children: [
                                                Container(
                                                    height: remainingHeight - 200,
                                                    padding: EdgeInsets.only(left: marginsAndPadding, top: marginsAndPadding),
                                                    child: Column(
                                                        children: [
                                                            Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: Text('Recent Workouts', style: TextStyle(
                                                                    fontSize: 24, 
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.white,
                                                                )),
                                                            ),
                                                            SizedBox(height: sizedBoxSize),  
                                                        ]
                                                    ) 
                                                ),
                                                
                                            ],
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
            }
        );
  	}
}