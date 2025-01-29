import 'package:flutter/material.dart';
import 'package:flutter_app/Themes/theme.dart';
import 'package:flutter_app/Widgets/appbar.dart';
import 'package:flutter_app/Widgets/bottom_nav_bar.dart';
import 'package:flutter_app/Widgets/button_with_icon.dart';
import 'package:flutter_app/Scaffolds/Account/account.dart';
import 'package:flutter_app/Widgets/sidebar.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({super.key});

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final TextEditingController waterGoalController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    // get total number of workouts logged by user
        int numberOfWorkouts = 0;


    return Scaffold(
            key: _scaffoldKey,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(55.0), // Increase AppBar height
                child: MyAppBar(sidebarState: _scaffoldKey, title: 'Edit Account'),
            ),
            drawer: const SideBar(),
            body: SingleChildScrollView(
                child: Container(
                    margin: const EdgeInsets.all(16.0),
                    child: Column(
                        children: <Widget>[
                            // Top container (account details)
                            Container(
                                margin: const EdgeInsets.only(bottom: 16.0),
                                height: 350,
                                decoration: BoxDecoration(
                                    color: primaryThemeColour,
                                    borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Center(
                                    child: Column(
                                        children: <Widget>[
                                            const SizedBox(height: 16),
                                            const Icon(
                                                Icons.account_circle,
                                                size: 100,
                                                color: Colors.white,
                                            ),
                                            const SizedBox(height: 16),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                    const Text('Josh Ford', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                                    const SizedBox(width: 10),
                                                    ButtonWithIcon(
                                                        onClick: () {
                                                            // Handle save logic here
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(builder: (context) => const Account()),
                                                            );
                                                        },
                                                        colour: secondaryThemeColour,
                                                        icon: Icons.save,
                                                        text: 'Save'
                                                    ),
                                                ]
                                            ),
                                            const SizedBox(height: 16),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                    Column(
                                                        children: [
                                                            const Text('Total # of Workouts', style: TextStyle(color: Colors.white, fontSize: 16)),
                                                            Text('$numberOfWorkouts', style: const TextStyle(color: Colors.white, fontSize: 16)),
                                                        ]
                                                    ),
                                                    const Column(
                                                        children: [
                                                            Text('Water Goal', style: TextStyle(color: Colors.white, fontSize: 16)),
                                                            Row(
                                                                children: [
                                                                    //TextField()
                                                                ],
                                                            )
                                                        ]
                                                    )
                                                ]
                                            )
                                        ],
                                    ),
                                ),
                            ),
                            // Add more containers here as needed
                        ],
                    ),
                ),
            ),
            bottomNavigationBar: const BottomNavBar(page: 'account'),
        );
    }
}
