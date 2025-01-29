import 'package:flutter/material.dart';
//import 'package:flutter_app/Scaffolds/account.dart';
import 'package:flutter_app/Themes/theme.dart';

class MyAppBar extends StatefulWidget {
  final GlobalKey<ScaffoldState> sidebarState;
  final String title;

  const MyAppBar({super.key, required this.sidebarState, required this.title});

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  
  @override
  Widget build(BuildContext context) {  

    return AppBar(
          backgroundColor: primaryThemeColour,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu, // Default hamburger icon
                  size: 40.0,
                  color: secondaryThemeColour, // Color of the icon
                ),
                onPressed: () {
                    widget.sidebarState.currentState!.openDrawer(); // Open the drawer if closed
                },
              );
            },
          ),
          title: Text(widget.title, style: const TextStyle(color: Colors.white)),
          centerTitle: true, // Center the title and icons
          /* actions: [
            IconButton(
              icon: const Icon(
                Icons.account_circle, 
                size: 40.0, 
                color: secondaryThemeColour,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Account()),
                );
              },
            ),
          ], */
          bottom: PreferredSize(
            preferredSize:  const Size.fromHeight(2.0),
            child: Container(
              color: tertiaryThemeColour,
              height: 1.0,
            ),
          ),
        );
  }
}