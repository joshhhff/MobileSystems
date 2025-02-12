import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gym_journal_app/Scaffolds/Popups/log_water.dart';
import 'package:gym_journal_app/Themes/theme.dart';

class QuickEntries extends StatefulWidget {
    final bool refreshWaterPage;
    final bool refreshWorkoutPage;

    const QuickEntries({super.key, required this.refreshWaterPage, required this.refreshWorkoutPage});

    @override
    State<QuickEntries> createState() => _QuickEntriesState();
}

class _QuickEntriesState extends State<QuickEntries> {

    @override
    Widget build(BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.0),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                    ),
                ),
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 90.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            const Center(
                                child: Text(
                                    'Quick Entry',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                    ),
                                ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                    GestureDetector(
                                        onTap: () {
                                            Navigator.of(context).pop(); // Close the current modal
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                    return BackdropFilter(
                                                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                                        child: AlertDialog(
                                                            backgroundColor: primaryThemeColour,
                                                            title: const Center(
                                                                child: Text(
                                                                    'Log Exercise',
                                                                    style: TextStyle(color: Colors.white),
                                                                ),
                                                            ),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(8.0),
                                                            ),
                                                            content: const Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                    SizedBox(height: 16),
                                                                    Text(
                                                                        'Exercise details go here...',
                                                                        style: TextStyle(
                                                                            fontSize: 18,
                                                                            color: Colors.white,
                                                                        ),
                                                                    ),
                                                                ],
                                                            ),
                                                        ),
                                                    );
                                                },
                                            );
                                        },
                                        child: Column(
                                            children: [
                                                Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: primaryThemeColour,
                                                            width: 5.0,
                                                        ),
                                                    ),
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: const Icon(
                                                        Icons.fitness_center,
                                                        size: 50,
                                                        color: Colors.white,
                                                    ),
                                                ),
                                                const SizedBox(height: 16),
                                                const Text(
                                                    'Log Exercise',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                    ),
                                                ),
                                            ],
                                        ),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                            Navigator.of(context).pop(); // Close the current modal
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                    return BackdropFilter(
                                                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                                        child: LogWater(refreshNeeded: widget.refreshWaterPage),
                                                    );
                                                },
                                            );
                                        },
                                        child: Column(
                                            children: [
                                                Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: primaryThemeColour,
                                                            width: 5.0,
                                                        ),
                                                    ),
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: const Icon(
                                                        Icons.local_drink,
                                                        size: 50,
                                                        color: Colors.white,
                                                    ),
                                                ),
                                                const SizedBox(height: 16),
                                                const Text(
                                                    'Log Water',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                    ),
                                                ),
                                            ],
                                        ),
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