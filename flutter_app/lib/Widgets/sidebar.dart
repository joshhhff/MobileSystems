import 'package:flutter/material.dart';
import 'package:flutter_app/Scaffolds/Account/account.dart';
import 'package:flutter_app/Scaffolds/home.dart';
import 'package:flutter_app/Scaffolds/login.dart';
import 'package:flutter_app/Scaffolds/workouts.dart';
import 'package:flutter_app/Themes/theme.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    
    return Drawer(
        backgroundColor: const Color.fromARGB(255, 70, 77, 88),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: secondaryThemeColour,
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
                  Icon(Icons.fitness_center, size: 50, color: primaryThemeColour),
                  SizedBox(width: 10), // Add spacing between the icon and the text
                  Text(
                    'GymJournal',
                    style: TextStyle(
                    color: primaryThemeColour,
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
              iconColor: Colors.white,
              textColor: Colors.white,
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
              iconColor: Colors.white,
              textColor: Colors.white,
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
              iconColor: Colors.white,
              textColor: Colors.white,
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
              iconColor: Colors.white,
              textColor: Colors.white,
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
              iconColor: Colors.white,
              textColor: Colors.white,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              iconColor: Colors.white,
              textColor: Colors.white,
              onTap: () {
                // add in logout logic here

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