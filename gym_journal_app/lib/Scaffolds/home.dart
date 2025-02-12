
import 'package:flutter/material.dart';
import 'package:gym_journal_app/Models/Result.dart';
import 'package:gym_journal_app/Models/WaterConsumed.dart';
import 'package:gym_journal_app/Services/Database/database_controller.dart';
import 'package:gym_journal_app/Themes/theme.dart';
import 'package:gym_journal_app/Widgets/appbar.dart';
import 'package:gym_journal_app/Widgets/bottom_nav_bar.dart';
import 'package:gym_journal_app/Widgets/home_dashboard.dart';
import 'package:gym_journal_app/Widgets/sidebar.dart';
import 'package:gym_journal_app/Widgets/water_progress.dart';

class MyHomePage extends StatefulWidget {
    const MyHomePage({super.key});

    @override
    State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    // Create a GlobalKey for the ScaffoldState
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final _databaseController = DatabaseController();

    // get water consumed for day from database
    //double waterConsumed = 1.2;

    
    
    Future<Result> getWaterConsumed() async {
        try {
            Result waterConsumed = await _databaseController.getWaterConsumed();

            if (waterConsumed.success) {
                return Result(success: true, message: 'Water entries retrieved successfully', data: waterConsumed.data);
            } else {
                return Result(success: false, message: 'Error retrieving water entries');
            }
        } catch(e) {
            return Result(success: false, message: e.toString());
        }
    }

    @override
    Widget build(BuildContext context) {
        return FutureBuilder(
            future: _databaseController.RetrieveUserDetails(),
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
                    var details = snapshot.data?.data.docs[0];

                    return FutureBuilder<Result>(
                        future: getWaterConsumed(),
                        builder: (context, waterSnapshot) {
                            if (waterSnapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                        color: primaryThemeColour,
                                    ),
                                );
                            } else if (waterSnapshot.hasError) {
                                return Center(child: Text('Error: ${waterSnapshot.error}'));
                            } else {
                                var waterConsumed = waterSnapshot.data?.data ?? 0.0;
                                print('water consumed: $waterConsumed');

                                WaterConsumed waterDetails = waterConsumed;
                                
                                return Scaffold(
                                    key: _scaffoldKey,
                                    appBar: PreferredSize(
                                        preferredSize: const Size.fromHeight(60.0), // Increase AppBar height
                                        child: MyAppBar(sidebarState: _scaffoldKey, title: 'Home'),
                                    ),
                                    drawer: const SideBar(),
                                    body: SingleChildScrollView(
                                        child: Column(
                                            children: <Widget>[
                                                Container(
                                                    margin: const EdgeInsets.all(25.0),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                            Text(
                                                                'Welcome, ${details['firstName']}!',
                                                                style: TextStyle(
                                                                    color: primaryThemeColour,
                                                                    fontSize: 32.0,
                                                                    fontWeight: FontWeight.bold,
                                                                ),
                                                            ),
                                                            const SizedBox(height: 10),
                                                            Text(
                                                                'Manage your workouts and track your progress easily with GymJournal',
                                                                style: TextStyle(
                                                                    color: primaryThemeColour,
                                                                    fontSize: 20.0,
                                                                ),
                                                            ),
                                                            // Add more content here
                                                        ],
                                                    ),
                                                ),
                                                Container(
                                                    constraints: BoxConstraints(
                                                        minHeight: 0,
                                                        maxHeight: double.infinity,
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color: primaryThemeColour,
                                                        borderRadius: BorderRadius.only(topRight: Radius.circular(50.0)),
                                                    ),
                                                    child: Center(
                                                        child: Column(
                                                            children: <Widget>[
                                                                Align(
                                                                    alignment: Alignment.topLeft,
                                                                    child: Column(
                                                                        children: <Widget>[
                                                                            Padding(
                                                                                padding: EdgeInsets.all(25.0),
                                                                                child: Align(
                                                                                    alignment: Alignment.centerLeft,
                                                                                    child: Text(
                                                                                        'Dashboard',
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: 24.0,
                                                                                            color: Colors.white,
                                                                                        ),
                                                                                    ),
                                                                                ),
                                                                            ),
                                                                            Padding(
                                                                                padding: EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
                                                                                child: Dashboard(),
                                                                            ),
                                                                            
                                                                        ],
                                                                    ),
                                                                ),
                                                                WaterProgress(details: details, waterDetails: waterDetails)
                                                            ],
                                                        ),
                                                    ),
                                                )
                                                // Add more containers here as needed
                                            ],
                                        ),
                                    ),
                                    bottomNavigationBar: const BottomNavBar(page: 'home'),
                                );
                            }
                        },
                    );
                }
            },
        );
    }
}
