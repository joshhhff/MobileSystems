import 'package:flutter/material.dart';
import 'package:gym_journal_app/Models/Result.dart';
import 'package:gym_journal_app/Services/Database/database_controller.dart';
import 'package:gym_journal_app/Themes/theme.dart';

class ExerciseList extends StatefulWidget {
    const ExerciseList({super.key});

    @override
    State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
    final _databaseController = DatabaseController();

    void displayExerciseInfo(Map<String, dynamic> exercise) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
            return AlertDialog(
                title: const Text('Exercise Information'),
                content: Text('Exercise Name: ${exercise['name']}\nTargets: ${exercise['target']}'),
                actions: <Widget>[
                TextButton(
                    onPressed: () {
                    Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                ),
                ],
            );
            },
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Exercise List', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                backgroundColor: primaryThemeColour,
                iconTheme: IconThemeData(
                    color: Colors.white, // Change this to your desired color
                ),
            ),
            body: FutureBuilder<Result>(
                future: _databaseController.getAllExercises(),
                builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData) {
                        return Center(child: Text('No exercises found.'));
                    } else {
                        final data = snapshot.data!.data as Map<String, List<dynamic>>;

                        return ListView.builder(
                            itemCount: data.keys.length,
                            itemBuilder: (context, index) {
                                final bodyPart = data.keys.elementAt(index);
                                final exercises = data[bodyPart]!;

                                return ExpansionTile(
                                    title: Text(
                                        bodyPart,
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                    children: exercises.map((exercise) {
                                        return GestureDetector(
                                            onTap: () {
                                                Navigator.pop(context, exercise);
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: primaryThemeColour,
                                                    borderRadius: BorderRadius.circular(10),
                                                ),
                                                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                child: ListTile(
                                                    title: Text(
                                                        exercise['name'],
                                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                    ),
                                                    trailing: IconButton(
                                                        icon: Icon(Icons.info, color: Colors.white),
                                                        onPressed: () {
                                                            // Handle info icon press
                                                            displayExerciseInfo(exercise);
                                                        },
                                                    ),
                                                ),
                                            ),
                                        );
                                    }).toList(),
                                );
                            },
                        );
                    }
                },
            ),
        );
    }
}

class Exercise {
    final String name;
    final String description;

    Exercise({required this.name, required this.description});
}
