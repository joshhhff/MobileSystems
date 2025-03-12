import 'package:flutter/material.dart';
import 'package:gym_journal_app/Scaffolds/Account/settings.dart';
import 'package:gym_journal_app/Scaffolds/Workouts/workouts.dart';
import 'package:gym_journal_app/Scaffolds/water_logs.dart';
import 'package:gym_journal_app/Themes/theme.dart';

class Dashboard extends StatefulWidget {
    const Dashboard({super.key});

    @override
    State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

    @override
    Widget build(BuildContext context) {
        // get water goal from database
        double waterGoal = 3.5;

        // get water consumed for day from database
        double waterConsumed = 1.2;

        return Column(
            children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                        GestureDetector(
                            onTap: () {
                                // Navigate to workout history page
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const Workout()),
                                );
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 200,
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Icon(Icons.fitness_center, size: 60, color: primaryThemeColour),
                                        SizedBox(height: 8.0),
                                        Text('Workout History', textAlign: TextAlign.center, style: TextStyle(color: primaryThemeColour, fontSize: 20)),
                                    ],
                                ),
                            ),
                        ),
                        GestureDetector(
                            onTap: () {
                                // Navigate to workout history page
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const WaterLogs()),
                                );
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 200,
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Icon(Icons.local_drink, size: 60, color: primaryThemeColour),
                                        SizedBox(height: 8.0),
                                        Text('Water', textAlign: TextAlign.center, style: TextStyle(color: primaryThemeColour, fontSize: 20)),
                                    ],
                                ),
                            ),
                        ),
                    ],
                ),
                SizedBox(height: 16.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                        GestureDetector(
                            onTap: () {
                                // Navigate to workout history page
                                showDialog(context: context, builder: (context) {
                                    return AlertDialog(
                                        title: Text('Workout History'),
                                        content: Text('Workout history goes here'),
                                        actions: [
                                            TextButton(
                                                onPressed: () {
                                                    Navigator.pop(context);
                                                },
                                                child: Text('Close'),
                                            ),
                                        ],
                                    );
                                });
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 200,
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Icon(Icons.checklist, size: 60, color: primaryThemeColour),
                                        SizedBox(height: 8.0),
                                        Text('Manage Goals', textAlign: TextAlign.center, style: TextStyle(color: primaryThemeColour, fontSize: 20)),
                                    ],
                                ),
                            ),
                        ),
                        GestureDetector(
                            onTap: () {
                                // Navigate to workout history page
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const Settings()),
                                );
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 200,
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Icon(Icons.settings, size: 60, color: primaryThemeColour),
                                        SizedBox(height: 8.0),
                                        Text('Settings', textAlign: TextAlign.center, style: TextStyle(color: primaryThemeColour, fontSize: 20)),
                                    ],
                                ),
                            ),
                        ),
                    ],
                ),
                
            ],
        );
    }
}
