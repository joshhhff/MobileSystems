import 'package:flutter/material.dart';
import 'package:flutter_app/Scaffolds/Account/account.dart';
import 'package:flutter_app/Scaffolds/entries.dart';
import 'package:flutter_app/Scaffolds/home.dart';
import 'package:flutter_app/Scaffolds/workouts.dart';
import 'package:flutter_app/Themes/theme.dart';
import 'package:flutter_app/Widgets/multi_select_button.dart';

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
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: tertiaryThemeColour, // Color of the thin line
            width: 1.0, // Width of the thin line
          ),
        ),
      ),
      child: BottomAppBar(
        color: primaryThemeColour,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // HOME ICON
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      size: 40.0,
                      color: widget.page == 'home' ? secondaryThemeColour : tertiaryThemeColour,
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
                      color: widget.page == 'exercise' ? secondaryThemeColour : tertiaryThemeColour,
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
                      Icons.description,
                      size: 40.0,
                      color: widget.page == 'logs' ? secondaryThemeColour : tertiaryThemeColour,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Entries()),
                      );
                    },
                  ),
                  // ACCOUNT ICON
                  IconButton(
                    icon: Icon(
                      Icons.account_circle,
                      size: 40.0,
                      color: widget.page == 'account' ? secondaryThemeColour : tertiaryThemeColour,
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
            ],
          ),
        ),
      ),
    );
  }
}