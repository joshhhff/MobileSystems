import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:gym_journal_app/Themes/theme.dart';

class Stopwatch extends StatefulWidget {
    const Stopwatch({super.key}); // Ensure key is passed correctly

    @override
    StopwatchState createState() => StopwatchState();
}

class StopwatchState extends State<Stopwatch> {
    late Timer _timer;
    int _seconds = 0;
    bool _isRunning = false;
    bool _isPaused = false;

    @override
    void dispose() {
        if (_isRunning) {
            _timer.cancel();
        }
        super.dispose();
    }

    int getDuration() {
        return _seconds;
    }

    void startStopwatch() {
        if (!_isRunning) {
            _timer = Timer.periodic(Duration(seconds: 1), (timer) {
                setState(() {
                    _seconds++;
                });
            });
            setState(() {
                _isRunning = true;
                _isPaused = false;
            });
        }
    }

    void stopStopwatch() {
        if (_isRunning) {
            _timer.cancel();
            setState(() {
                _isRunning = false;
                _isPaused = true;
            });
        }
    }

    /* 
    void _resetStopwatch() {
        _timer.cancel();
        setState(() {
            _seconds = 0;
            _isRunning = false;
        });
    } */

    /* void _showResetConfirmationDialog() {
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: Text('Confirm Reset'),
                    content: Text('Are you sure you want to reset the stopwatch?'),
                    actions: <Widget>[
                        TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                                Navigator.of(context).pop();
                            },
                        ),
                        TextButton(
                            child: Text('Reset'),
                            onPressed: () {
                                _resetStopwatch();
                                Navigator.of(context).pop();
                            },
                        ),
                    ],
                );
            },
        );
    } */

    @override
    Widget build(BuildContext context) {
        int hours = (_seconds / 3600).floor();
        int minutes = (_seconds % 3600 / 60).floor();
        int seconds = _seconds % 60;

        _isPaused ? null : startStopwatch();

        return Container(
            height: 100,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Text(
                        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                        ),
                    ),
                    SizedBox(height: 20),
                    if (_isPaused)
                        IconButton(
                            icon: Icon(
                                Icons.play_arrow,
                                size: 40.0,
                                color: Colors.white,
                            ),
                            onPressed: () {
                                startStopwatch();
                            },
                        ),
                    if (!_isPaused)
                        IconButton(
                            icon: Icon(
                                Icons.stop,
                                size: 40.0,
                                color: Colors.white,
                            ),
                            onPressed: () {
                                stopStopwatch();
                            },
                        ),
                ],
            ),
        );
    }
}
