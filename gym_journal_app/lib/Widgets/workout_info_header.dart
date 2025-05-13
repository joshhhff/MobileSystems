import 'package:flutter/material.dart';
import 'package:gym_journal_app/Scaffolds/Workouts/new_workout.dart';
import 'package:gym_journal_app/Themes/theme.dart';
import 'package:gym_journal_app/Widgets/button_with_icon.dart';

class WorkoutInfoHeader extends StatelessWidget {
    final double marginsAndPadding;
    final double sizedBoxSize;
    final String exerciseName;
    final Function onDelete;

    const WorkoutInfoHeader({super.key, required this.marginsAndPadding, required this.sizedBoxSize, required this.exerciseName, required this.onDelete});

    @override
    Widget build(BuildContext context) {
        return Container(
            margin: EdgeInsets.all(marginsAndPadding),
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                  exerciseName,
                  style: TextStyle(
                    color: primaryThemeColour,
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  SizedBox(height: sizedBoxSize),
                  Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                    final RenderBox iconBox = context.findRenderObject() as RenderBox;
                    final Offset iconPosition = iconBox.localToGlobal(Offset.zero);
                    final double iconWidth = iconBox.size.width;
                    final double iconHeight = iconBox.size.height;

                    showMenu(
                      color: Color.fromARGB(255, 31, 149, 245),
                      context: context,
                      position: RelativeRect.fromLTRB(
                      iconPosition.dx + iconWidth, // Position menu to the right of the icon
                      iconPosition.dy + iconHeight, // Position menu below the icon
                      0, // No offset on the left
                      0, // No offset on the bottom
                      ),
                      items: [
                      /* PopupMenuItem(
                        child: ListTile(
                        leading: Icon(Icons.copy, color: Colors.white),
                        title: Text('Copy Workout', style: TextStyle(color: Colors.white)),
                        onTap: () {
                          // Add logic for copying workout
                          Navigator.pop(context);
                        },
                        ),
                      ), */
                      PopupMenuItem(
                        child: ListTile(
                        leading: Icon(Icons.delete, color: Colors.white),
                        title: Text('Delete Workout', style: TextStyle(color: Colors.white)),
                        onTap: () {
                          // Add logic for deleting workout
                          onDelete();
                        },
                        ),
                      ),
                      ],
                    );
                    },
                    child: Icon(
                    Icons.more_vert,
                    size: 40,
                    color: const Color.fromARGB(255, 75, 73, 73),
                    ),
                  ),
                  ),
                ],
            ),
        );
    }
}