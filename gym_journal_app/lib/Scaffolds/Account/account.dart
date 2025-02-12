import 'package:flutter/material.dart';
import 'package:gym_journal_app/Scaffolds/Account/edit_account.dart';
import 'package:gym_journal_app/Scaffolds/Account/settings.dart';
import 'package:gym_journal_app/Services/Database/database_controller.dart';
import 'package:gym_journal_app/Themes/theme.dart';
import 'package:gym_journal_app/Widgets/appbar.dart';
import 'package:gym_journal_app/Widgets/bottom_nav_bar.dart';
import 'package:gym_journal_app/Widgets/button_with_icon.dart';
import 'package:gym_journal_app/Widgets/sidebar.dart';

class Account extends StatefulWidget {
    const Account({super.key});

    @override
    State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final _databaseController = DatabaseController();
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
                    var userDetails = snapshot.data?.data.docs[0].data();
                    String firstName = userDetails['firstName'];
                    String lastName = userDetails['lastName'];
                    String email = userDetails['email'];
                    dynamic workoutGoal = userDetails['workoutGoal'] != null
                        ? (userDetails['workoutGoal'] as num).toInt()
                        : 'Not set';
                    dynamic waterGoal = userDetails['waterGoal'] != null
                        ? (userDetails['waterGoal'] as num).toDouble()
                        : 'Not set';
                    String unitPreference = userDetails['waterGoal'] != null
                        ? userDetails['waterUnit'] + 's'
                        : '';
                    String joinDate = userDetails['joinDate'];
        
                    return Scaffold(
                        key: _scaffoldKey,
                        appBar: PreferredSize(
                            preferredSize: const Size.fromHeight(55.0), // Increase AppBar height
                            child: MyAppBar(sidebarState: _scaffoldKey, title: 'Account'),
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
                                                Row(
                                                    children: [
                                                        Icon(
                                                            Icons.account_circle,
                                                            size: 100,
                                                            color: primaryThemeColour,
                                                        ),
                                                        const SizedBox(width: 10),
                                                        Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                                Text(
                                                                    '$firstName $lastName',
                                                                    style: TextStyle(
                                                                        color: primaryThemeColour,
                                                                        fontSize: 32.0,
                                                                        fontWeight: FontWeight.bold,
                                                                    ),
                                                                ),
                                                                Text(email, 
                                                                    style: TextStyle(
                                                                        color: primaryThemeColour, 
                                                                        fontSize: 18,
                                                                    )
                                                                ),
                                                            ]
                                                        )         
                                                    ]
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                    children: [
                                                        ButtonWithIcon(text: 'Edit', icon: Icons.edit, textColour: Colors.white, colour: primaryThemeColour, onClick: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(builder: (context) => const EditAccount()),
                                                            );
                                                        }),
                                                        SizedBox(width: 10),
                                                        ButtonWithIcon(text: 'Settings', icon: Icons.settings, textColour: Colors.white, colour: primaryThemeColour, onClick: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(builder: (context) => const Settings()),
                                                            );
                                                        }),
                                                    ]
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
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0)),
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
                                                                            'Joined on $joinDate',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 28.0,
                                                                                color: Colors.white,
                                                                            ),
                                                                        ),
                                                                    ),
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.all(25.0),
                                                                    child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(
                                                                            'Preferences',
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
                                                                    child: Row(
                                                                        children: [
                                                                            Text('Weekly Workout Goal - ', style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)),
                                                                            Text(' $workoutGoal', style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)),
                                                                        ],)
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
                                                                    child: Row(
                                                                        children: [
                                                                            Text('Daily Water Goal - ', style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)),
                                                                            Text(' $waterGoal $unitPreference', style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)),
                                                                        ],)
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                                                                    child: Divider(
                                                                        color: Colors.white,
                                                                        thickness: 1.0,
                                                                    ),
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.all(25.0),
                                                                    child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(
                                                                            'Details',
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
                                                                    child: Row(
                                                                        children: [
                                                                            Text('Total Workouts - ', style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)),
                                                                            Text(' totalWorkouts', style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)),
                                                                        ],)
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
                                                                    child: Row(
                                                                        children: [
                                                                            Text('Total Water - ', style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)),
                                                                            Text(' totalWater', style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)),
                                                                        ],)
                                                                ),
                                                            ],
                                                        ),
                                                    ),
                                                ],
                                            ),
                                        ),
                                    )
                                    // Add more containers here as needed
                                ],
                            ),
                        ),
                        bottomNavigationBar: const BottomNavBar(page: 'account'),
                    );
                }
            }
        );
    }
}
