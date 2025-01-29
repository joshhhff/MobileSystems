import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_app/Themes/theme.dart';

class MultiSelectButton extends StatefulWidget {
    const MultiSelectButton({super.key});

    @override
    State<MultiSelectButton> createState() => _MultiSelectButtonState();
}

class _MultiSelectButtonState extends State<MultiSelectButton> {
    void showModal(BuildContext context) {
        showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
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
                                        child: Text('Quick Entry', style: TextStyle(color: secondaryThemeColour, fontSize: 22.0, fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(height: 16),
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
                                                                child: Text('Log Exercise', style: TextStyle(color: secondaryThemeColour)),
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
                                                                        style: TextStyle(fontSize: 18, color: secondaryThemeColour),
                                                                    ),
                                                                ],
                                                            ),
                                                        ),
                                                    );
                                                },
                                            );
                                        },
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                                Column(
                                                    children: [
                                                        Container(
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                border: Border.all(color: Colors.orange, width: 1.0),
                                                            ),
                                                            padding: const EdgeInsets.all(16.0),
                                                            child: const Icon(Icons.fitness_center, size: 50, color: secondaryThemeColour),
                                                        ),
                                                        const SizedBox(height: 16),
                                                        const Text(
                                                            'Log Exercise',
                                                            style: TextStyle(fontSize: 18, color: secondaryThemeColour),
                                                        ),
                                                    ],
                                                ),
                                                const SizedBox(width: 20), // Add spacing between options
                                                Column(
                                                    children: [
                                                        Container(
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                border: Border.all(color: Colors.orange, width: 1.0),
                                                            ),
                                                            padding: const EdgeInsets.all(16.0),
                                                            child: const Icon(Icons.local_drink, size: 50, color: secondaryThemeColour),
                                                        ),
                                                        const SizedBox(height: 16),
                                                        const Text(
                                                            'Log Water',
                                                            style: TextStyle(fontSize: 18, color: secondaryThemeColour),
                                                        ),
                                                    ],
                                                ),
                                            ],
                                        ),
                                    ),
                                ],
                            ),
                        ),
                    ),
                );
            },
        );
    }

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: () {
                showModal(context);
            },
            child: Container(
                width: 50.0, // Increase width
                height: 50.0, // Increase height
                decoration: BoxDecoration(
                    color: secondaryThemeColour,
                    shape: BoxShape.circle,
                    boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3), // changes position of shadow
                        ),
                    ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 40.0), // Increase icon size
            ),
        );
    }
}
