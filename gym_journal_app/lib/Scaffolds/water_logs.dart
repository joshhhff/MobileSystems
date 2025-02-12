import 'package:flutter/material.dart';
import 'package:gym_journal_app/Models/Result.dart';
import 'package:gym_journal_app/Scaffolds/Popups/quick_entries.dart';
import 'package:gym_journal_app/Services/Database/database_controller.dart';
import 'package:gym_journal_app/Themes/theme.dart';
import 'package:gym_journal_app/Widgets/appbar.dart';
import 'package:gym_journal_app/Widgets/bottom_nav_bar.dart';
import 'package:gym_journal_app/Widgets/button_with_icon.dart';
import 'package:gym_journal_app/Widgets/sidebar.dart';
import 'package:gym_journal_app/Widgets/water_progress.dart';

class WaterLogs extends StatefulWidget {
  const WaterLogs({super.key});

  @override
  State<WaterLogs> createState() => _WaterLogsState();
}

class _WaterLogsState extends State<WaterLogs> {
	final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final _databaseController = DatabaseController();

    Future<Result> fetchAllData() async {
        try {
            var entries = await _databaseController.RetrieveCollection('entries', 'water');
            if (entries.success) {
                var snapshot = entries.data;
                var waterEntries = snapshot.docs.map((doc) => doc.data()).toList();
                waterEntries.sort((a, b) => DateTime.parse(b['dateCreated']).compareTo(DateTime.parse(a['dateCreated'])));

                Result dailyWaterConsumed = await getWaterConsumed();
                Result userDetails = await _databaseController.RetrieveUserDetails();

                if (dailyWaterConsumed.success && userDetails.success) {
                    return Result(success: true, message: '', data: [waterEntries, dailyWaterConsumed.data, userDetails.data]);
                } else {
                    return Result(success: false, message: dailyWaterConsumed.message);
                }
            } else {
                return Result(success: false, message: entries.message);
            }
        } catch (e) {
            return Result(success: false, message: e.toString());
        }
    }

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

    void showModal(BuildContext context) {
        showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
            return QuickEntries(refreshWaterPage: true, refreshWorkoutPage: false);
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
                        final waterLogs = result.data[0];
                        final dailyWaterConsumed = result.data[1];
                        final userDetails = result.data[2].docs[0].data();
                        print('user details: $userDetails');

                        return Scaffold(
                        key: _scaffoldKey,
                        appBar: PreferredSize(
                            preferredSize: const Size.fromHeight(55.0), // Increase AppBar height
                            child: MyAppBar(sidebarState: _scaffoldKey, title: 'Water Logs'),
                        ),
                        drawer: const SideBar(),
                        body: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
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
                                                    'Water Logs',
                                                    style: TextStyle(
                                                        color: primaryThemeColour,
                                                        fontSize: 32.0,
                                                        fontWeight: FontWeight.bold,
                                                    ),
                                                ),
                                                const SizedBox(height: 10),
                                                ButtonWithIcon(
                                                    text: 'Log Water', 
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
                                        height: MediaQuery.of(context).size.height - 350, // Adjust the height as needed
                                        decoration: BoxDecoration(
                                            color: primaryThemeColour,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(50.0),
                                            ),
                                        ),
                                        child: Column(
                                            children: [
                                                Container(
                                                    padding: const EdgeInsets.only(top: 25.0),
                                                    child: WaterProgress(details: userDetails, waterDetails: dailyWaterConsumed),
                                                ),
                                                Container(
                                                    padding: EdgeInsets.only(left: 25.0),
                                                    child: Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text('Previous logs', style: TextStyle(
                                                            fontSize: 24, 
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                        )),
                                                    ),
                                                ),
                                                const SizedBox(height: 20),
                                                Container(
                                                padding: EdgeInsets.only(left: 25.0, right: 25.0),
                                                  height: 300,
                                                  child: ListView.builder(
                                                    itemCount: waterLogs.length,
                                                    itemBuilder: (context ,index) {
                                                      final element = waterLogs[index];
                                                  
                                                    return Container(
                                                          width: double.infinity,
                                                          margin: const EdgeInsets.only(bottom: 10.0),
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
                                                                  Icon(Icons.local_drink, size: 40, color: primaryThemeColour),
                                                                  Expanded(
                                                                      child: Text('${element['waterAmount']} ${element['waterUnits']}${element['waterAmount'] != 1 ? 's' : ''}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                                                  ),
                                                                  Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                                      children: [
                                                                          Text(element['drinkDate'], textAlign: TextAlign.right, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                                                          Text(element['drinkTime'], textAlign: TextAlign.right, style: TextStyle(fontSize: 14)),
                                                                      ],
                                                                  ),
                                                                  const SizedBox(width: 20),
                                                                  Icon(Icons.edit, size: 30, color: tertiaryThemeColour),
                                                              ],
                                                          ),
                                                      );
                                                  }),
                                                ),      
                                                if (waterLogs.isEmpty) 
                                                    Center(
                                                        heightFactor: 2.0,
                                                        child: Column(
                                                            children: [
                                                                Text('No water logged yet!',
                                                                    style: TextStyle( color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                                                ),
                                                                const SizedBox(height: 20),
                                                                ButtonWithIcon(
                                                                    text: 'Log Water', 
                                                                    icon: Icons.add, 
                                                                    textColour: primaryThemeColour, 
                                                                    colour: Colors.white,
                                                                    onClick: () { showModal(context); },
                                                                ),
                                                            ],
                                                        ),
                                                    ),
                                            ],
                                        ),
                                    ),
                                ],
                            ),
                        ),
                        bottomNavigationBar: const BottomNavBar(page: 'logs'),
                    );
                        
                    } else {
                        return Center(child: Text('Error: ${result.message}'));
                    }
                } else {
                    return Center(child: Text('No data found'));
                }
                }
            }
        );
  	}
}