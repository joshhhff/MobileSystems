import 'package:flutter/material.dart';
import 'package:gym_journal_app/Models/SetEntry.dart';
import 'package:gym_journal_app/Themes/theme.dart';
import 'package:flutter/services.dart';

class NewExcercise extends StatefulWidget {
    final String exerciseName;
    final Function(String) onDismiss;
    final Function(String, List<SetEntry>) onSetChange;
    final String uniqueKey;

    const NewExcercise({super.key, required this.exerciseName, required this.onDismiss, required this.onSetChange, required this.uniqueKey});

    @override
    State<NewExcercise> createState() => _NewExcerciseState(); 
}

class _NewExcerciseState extends State<NewExcercise> {
    List<SetEntry> sets = [SetEntry(
        weight: '',
        reps: '',
    )];

    @override
    void dispose() {
        // Dispose controllers when widget is removed
        for (var set in sets) {
            set.dispose();
        }
        super.dispose();
    }

    void addSet() {
        setState(() {
          sets.add(SetEntry(
                weight: '',
                reps: '',
            ));
        });
    }

    void updateSet(SetEntry set, int index) {
        setState(() {
            sets[index] = set;
            widget.onSetChange(widget.uniqueKey, sets);
        });
    }

    @override
    Widget build(BuildContext context) {
        return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
                widget.onDismiss(widget.uniqueKey);
            },
            background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: primaryThemeColour,
                    borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                            child: Text(
                                widget.exerciseName,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                        ),
                        const SizedBox(height: 10),
                        ...sets.asMap().entries.map((entry) {
                            int index = entry.key;
                            SetEntry set = entry.value;

                            return Dismissible(
                                key: Key(set.hashCode.toString()),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                    set.dispose(); // Dispose controllers before removing
                                    setState(() {
                                        sets.removeAt(index);
                                        widget.onSetChange(widget.uniqueKey, sets);

                                        if (sets.length == 0) widget.onDismiss(widget.uniqueKey);
                                    });
                                },
                                background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: const Icon(Icons.delete, color: Colors.white),
                                ),
                                child: Column(
                                    children: [
                                        Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    top: BorderSide(color: Colors.white.withOpacity(0.3), width: 0.5),
                                                    bottom: BorderSide(color: Colors.white.withOpacity(0.3), width: 0.5),
                                                ),
                                            ),
                                            child: Row(
                                                children: [
                                                    GestureDetector(
                                                        onTap: () {
                                                            setState(() {
                                                                set.isComplete = !set.isComplete;

                                                                updateSet(set, index);
                                                            });
                                                        },
                                                        child: Container(
                                                            width: 50,
                                                            height: 50,
                                                            decoration: BoxDecoration(
                                                                border: Border(
                                                                    left: BorderSide(
                                                                        color: set.isComplete ? secondaryThemeColour : Colors.transparent,
                                                                        width: 10,
                                                                    ),
                                                                    right: BorderSide(color: Colors.white.withOpacity(0.3), width: 0.5),
                                                                ),
                                                            ),
                                                            child: Center(
                                                                child: Text(
                                                                    '${index + 1}',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontSize: 18,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: set.isComplete ? secondaryThemeColour : Colors.white,
                                                                    ),
                                                                ),
                                                            ),
                                                        ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                        child: Row(
                                                            children: [
                                                                SizedBox(
                                                                    width: 50,
                                                                    child: TextField(
                                                                        controller: set.weightController,
                                                                        decoration: const InputDecoration(
                                                                            hintText: '0',
                                                                            hintStyle: TextStyle(color: Colors.white),
                                                                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                                                                            border: InputBorder.none,
                                                                        ),
                                                                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                                                                        style: const TextStyle(color: Colors.white),
                                                                    ),
                                                                ),
                                                                const SizedBox(width: 5),
                                                                const Text(
                                                                    'kg',
                                                                    style: TextStyle(color: Colors.white),
                                                                ),
                                                                const SizedBox(width: 50),
                                                                SizedBox(
                                                                    width: 50,
                                                                    child: TextField(
                                                                        controller: set.repsController,
                                                                        decoration: const InputDecoration(
                                                                            hintText: '0',
                                                                            hintStyle: TextStyle(color: Colors.white),
                                                                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                                                                            border: InputBorder.none,
                                                                        ),
                                                                        keyboardType: TextInputType.number,
                                                                        style: const TextStyle(color: Colors.white),
                                                                    ),
                                                                ),
                                                                const SizedBox(width: 5),
                                                                const Text(
                                                                    'reps',
                                                                    style: TextStyle(color: Colors.white),
                                                                ),
                                                            ],
                                                        ),
                                                    ),
                                                ],
                                            ),
                                        ),
                                    ],
                                ),
                            );
                        }).toList(),
                        TextButton.icon(
                            onPressed: () {
                                addSet();
                            },
                            icon: const Icon(Icons.add, color: Colors.white, size: 24, weight: 700),
                            label: const Text('Add Set', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                    ],
                ),
            ),
        );
    }
}
