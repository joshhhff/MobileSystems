import 'package:flutter/material.dart';
import 'package:gym_journal_app/Themes/theme.dart';

class WaterProgress extends StatefulWidget {
    dynamic details;
    dynamic waterDetails;
    WaterProgress({super.key, required this.details, required this.waterDetails});

  @override
  State<WaterProgress> createState() => _WaterProgressState();
}

class _WaterProgressState extends State<WaterProgress> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // align text
            children: [
                Text(
                    widget.details['waterGoal'] > 0 ? 'Your water goal is ${widget.details['waterGoal']} ${widget.details['waterUnit']}s a day, keep it up!' : 'Set a water goal to view progress!',
                    style: const TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        LinearProgressIndicator(
                            value: widget.details['waterGoal'] > 0 ? widget.waterDetails.waterConsumed / widget.waterDetails.waterGoal : 0,
                            backgroundColor: Colors.white,
                            minHeight: 10,
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            valueColor: const AlwaysStoppedAnimation<Color>(secondaryThemeColour),
                        ),
                        if (widget.details['waterGoal'] > 0)
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            '${widget.waterDetails.consumedInPreferredUnit.toStringAsFixed(2)} / ${widget.details['waterGoal']} litres consumed',
                                            style: const TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                                        ),
                                    ),
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                            '${widget.waterDetails.progress.toStringAsFixed(2)}%',
                                            style: const TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                                        ),
                                    ),
                                ],
                            ),
                    ],
                ),
            ],
        ),
    );
  }
}