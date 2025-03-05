import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_journal_app/Themes/theme.dart';

class Stopwatch extends StatefulWidget {
  @override
  _StopwatchState createState() => _StopwatchState();
}

class _StopwatchState extends State<Stopwatch> {
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

  void _startStopwatch() {
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

  void _stopStopwatch() {
    if (_isRunning) {
      _timer.cancel();
      setState(() {
        _isRunning = false;
        _isPaused = true;
      });
    }
  }

  void _resetStopwatch() {
    _timer.cancel();
    setState(() {
      _seconds = 0;
      _isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int hours = (_seconds / 3600).floor();
    int minutes = (_seconds % 3600 / 60).floor();
    int seconds = _seconds % 60;

    _isPaused ? null : _startStopwatch();

    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          if (_isPaused) IconButton(
            icon: Icon(
              Icons.play_arrow,
              size: 40.0,
              color: Colors.white,
            ),
            onPressed: () {
              _startStopwatch();
            },
          ),
          if (!_isPaused) IconButton(
            icon: Icon(
              Icons.stop,
              size: 40.0,
              color: Colors.white,
            ),
            onPressed: () {
              _stopStopwatch();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.restart_alt,
              size: 40.0,
              color: Colors.white,
            ),
            onPressed: () {
              _resetStopwatch();
            },
          ),
        ],
      ),
    );
  }
}
