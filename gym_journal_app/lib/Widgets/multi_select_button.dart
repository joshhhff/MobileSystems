import 'package:flutter/material.dart';
import 'package:gym_journal_app/Scaffolds/Popups/quick_entries.dart';
import 'package:gym_journal_app/Themes/theme.dart';

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
        return QuickEntries(refreshWaterPage: false, refreshWorkoutPage: false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.add_circle,
        size: 40.0,
        color: primaryThemeColour,
      ),
      onPressed: () {
        showModal(context);
      },
    );
}
}