import 'package:flutter/material.dart';
import 'package:gym_journal_app/Scaffolds/Account/account.dart';
import 'package:gym_journal_app/Themes/theme.dart';

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
          scrolledUnderElevation: 0,
                    backgroundColor: Colors.white,
                    leading: Transform.scale(
                        scale: 2, // Set the size of the leading icon (MenuIcon.png
                        child: Padding (
                            padding: const EdgeInsets.only(left: 16.0), // Add padding to the leading icon
                        child: Builder(
                            builder: (BuildContext context) {
                                return IconButton(
                                    icon: SizedBox(
                                        width: 36.0, // Set the width of the image
                                        height: 15.0, // Set the height of the image
                                        child: Image.asset(
                                            'lib/media/MenuIcon.png',
                                        ),
                                    ),
                                    onPressed: () {
                                            widget.sidebarState.currentState!.openDrawer(); // Open the drawer if closed
                                    },
                                );
                            },
                        ),
                        )
                    ),
                    title: Text(widget.title, style: const TextStyle(color: primaryThemeColour, fontWeight: FontWeight.bold)),
                    centerTitle: true, // Center the title and icons
                    actions: [
                        if (widget.title != 'Account') Padding(
                            padding: const EdgeInsets.only(right: 16.0), // Add padding to the action icon
                            child: IconButton(
                                icon: const Icon(
                                    Icons.account_circle, 
                                    size: 40.0, 
                                    color: primaryThemeColour,
                                ),
                                onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const Account()),
                                    );
                                },
                            ),
                        ),
                    ],
                );
    }
}
