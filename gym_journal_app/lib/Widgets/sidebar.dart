import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_journal_app/Scaffolds/Account/account.dart';
import 'package:gym_journal_app/Scaffolds/home.dart';
import 'package:gym_journal_app/Scaffolds/User%20Management/login.dart';
import 'package:gym_journal_app/Scaffolds/workouts.dart';
import 'package:gym_journal_app/Services/Authentication/Controllers/AuthenticationServices.dart';
import 'package:gym_journal_app/Themes/theme.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    final authenticationController = AuthenticationController();
    
    return Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: primaryThemeColour,
              ),
              child: Center(
                child: /* Text(
                  'My App',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: primaryThemeColour,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ), */
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Icon(Icons.fitness_center, size: 50, color: Colors.white),
                  SizedBox(width: 10), // Add spacing between the icon and the text
                  Text(
                    'GymJournal',
                    style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                  ],
                )
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              iconColor: primaryThemeColour,
              textColor: primaryThemeColour,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                );
              }
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Workouts'),
              iconColor: primaryThemeColour,
              textColor: primaryThemeColour,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Workout()),
                );
              }
            ),
            ListTile(
              leading: const Icon(Icons.local_drink),
              title: const Text('Water'),
              iconColor: primaryThemeColour,
              textColor: primaryThemeColour,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                );
              }
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Account'),
              iconColor: primaryThemeColour,
              textColor: primaryThemeColour,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Account()),
                );
              }
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              iconColor: primaryThemeColour,
              textColor: primaryThemeColour,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              iconColor: primaryThemeColour,
              textColor: primaryThemeColour,
              onTap: () async {
                // add in logout logic here
                await authenticationController.Logout();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              }
            ),
          ],
        ),
      );
  }
}