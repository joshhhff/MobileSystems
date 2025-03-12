import 'package:flutter/material.dart';
import 'dart:async';

import 'package:gym_journal_app/Themes/theme.dart';

class Countdown extends StatefulWidget {
  const Countdown({super.key});

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  static const int initialTime = 120; // 2 minutes in seconds
  int _remainingTime = initialTime;
  Timer? _timer;
  bool _isRunning = false;

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer!.cancel();
          _showPopup();
        }
      });
    });
    setState(() {
      _isRunning = true;
    });
  }

  void _pauseTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      _remainingTime = initialTime;
      _isRunning = false;
    });
  }

  void _showPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
            Icons.timer,
            color: Colors.white,
            size: 50,
              ),
              const SizedBox(height: 10),
              const Text(
            'Rest over!',
            style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetTimer();
            },
            child: const Text('Dismiss'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${(_remainingTime ~/ 60).toString().padLeft(2, '0')}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 25, color: primaryThemeColour),
        ),
        const SizedBox(height: 20),
        Row(
                                            children: [
                                                if (!_isRunning) IconButton(
            icon: Icon(
              Icons.play_arrow,
              size: 40.0,
              color: primaryThemeColour,
            ),
            onPressed: () {
              _startTimer();
            },
          ),
          if (_isRunning) IconButton(
            icon: Icon(
              Icons.stop,
              size: 40.0,
              color: primaryThemeColour,
            ),
            onPressed: () {
              _pauseTimer();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.restart_alt,
              size: 40.0,
              color: primaryThemeColour,
            ),
            onPressed: () {
              _resetTimer();
            },
          ),
                                            ],
                                        ),
      ],
    );
  }
}