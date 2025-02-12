import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_journal_app/Models/Result.dart';
import 'package:gym_journal_app/Models/WaterLog.dart';
import 'package:gym_journal_app/Scaffolds/water_logs.dart';
import 'package:gym_journal_app/Services/Authentication/Controllers/AuthenticationServices.dart';
import 'package:gym_journal_app/Services/Database/database_controller.dart';
import 'package:gym_journal_app/Themes/theme.dart';
import 'package:gym_journal_app/Utilities/common_tools.dart';

class LogWater extends StatefulWidget {
    final bool refreshNeeded;
  const LogWater({super.key, required this.refreshNeeded});

  @override
  State<LogWater> createState() => _LogWaterState();
}

class _LogWaterState extends State<LogWater> {
    final _waterController = TextEditingController();
    final _unitController = TextEditingController();
    final _databaseController = DatabaseController();
    final _authController = AuthenticationController();
    final _toolsController = CommonTools();

    Future<Result> logWater(double amount, String units) async {
        try {
            // retrieve currently logged in user
            print('new water log - $amount + $units');
            if (units.isEmpty) {
              units = 'ml';
            }
            var user = await _authController.getCurrentUser();
            var userId = user!.uid;  // retrieve doc id for update

            WaterLog newWaterLog = WaterLog(
                dateCreated: _toolsController.getTimestamp(),    // ISO timestamp
                waterAmount: amount,
                waterUnits: units,
                userId: userId,
                drinkDate: _toolsController.getFormattedDate(),
                drinkTime: _toolsController.getCurrentTime(),
            );

            var logNewWater = await _databaseController.AddToCollection('entries', newWaterLog, 'water');

            return Result(success: true, message: '', data: logNewWater);
        } catch(e) {
            return Result(success: false, message: e.toString());
        }
    }
    
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
            backgroundColor: Colors.white,
            title: const Center(
                child: Text('Log Water', style: TextStyle(color: primaryThemeColour, fontWeight: FontWeight.bold)),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
            ),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    SizedBox(height: 16),
                    Text(
                        'Water intake details go here...',
                        style: TextStyle(fontSize: 18, color: primaryThemeColour),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Expanded(
                              flex: 2,
                                child: TextField(
                                    controller: _waterController,
                                    inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                                    ],
                                    style: const TextStyle(color: Colors.black),
                                )
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 1,
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                        filled: true,
                                        fillColor: primaryThemeColour,
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: primaryThemeColour),
                                        ),
                                    ),
                                    dropdownColor: primaryThemeColour,
                                    value: 'ml',
                                    items: <String>['ml', 'litre', 'pint']
                                        .map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value, style: TextStyle(color: Colors.white)),
                                            );
                                        }).toList(),
                                    onChanged: (String? newValue) {
                                        setState(() {
                                            _unitController.text = newValue!;
                                        });
                                    },
                                ),
                            )
                        ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: () async {
                            // Log water
                            Result logNewWater = await logWater(double.parse(_waterController.text), _unitController.text);

                            
                            if (logNewWater.success) {
                                if (widget.refreshNeeded) {    // in event of user logging water from water logs page, page should refresh when new water is logged
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => const WaterLogs()),
                                    );
                                } else {
                                    Navigator.pop(context);
                                }
                            } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: const Text('Log Water Failed'),
                                            content: Text(logNewWater.message),
                                            actions: <Widget>[
                                                TextButton(
                                                    onPressed: () {
                                                        Navigator.of(context).pop();
                                                    },
                                                    child: const Text('OK'),
                                                ),
                                            ],
                                        );
                                    },
                                );
                            }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(primaryThemeColour),
                        ),
                        child: const Text(style: TextStyle(color: Colors.white), 'Log Water')
                    ),
                ],
            ),
    );
  }
}