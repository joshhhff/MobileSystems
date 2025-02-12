import 'package:flutter/material.dart';
import 'package:gym_journal_app/Scaffolds/Account/account.dart';
import 'package:gym_journal_app/Scaffolds/home.dart';
import 'package:gym_journal_app/Scaffolds/water_logs.dart';
import 'package:gym_journal_app/Scaffolds/workouts.dart';
import 'package:gym_journal_app/Themes/theme.dart';
import 'package:gym_journal_app/Widgets/multi_select_button.dart';

class BottomNavBar extends StatefulWidget {
  final String page;

  const BottomNavBar({super.key, required this.page});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryThemeColour, // Set the background color here
      child: Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 10,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // HOME ICON
                IconButton(
                  icon: Icon(
                    Icons.home,
                    size: 40.0,
                    color: widget.page == 'home' ? primaryThemeColour : tertiaryThemeColour,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyHomePage()),
                    );
                  },
                ),
                // WORKOUT ICON
                IconButton(
                  icon: Icon(
                    Icons.fitness_center,
                    size: 40.0,
                    color: widget.page == 'exercise' ? primaryThemeColour : tertiaryThemeColour,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Workout()),
                    );
                  },
                ),
                // MULTI SELECT ICON
                const MultiSelectButton(),
                
                // LOGS ICON
                IconButton(
                  icon: Icon(
                    Icons.local_drink,
                    size: 40.0,
                    color: widget.page == 'logs' ? primaryThemeColour : tertiaryThemeColour,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WaterLogs()),
                    );
                  },
                ),
                // ACCOUNT ICON
                IconButton(
                  icon: Icon(
                    Icons.account_circle,
                    size: 40.0,
                    color: widget.page == 'account' ? primaryThemeColour : tertiaryThemeColour,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Account()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}