import 'dart:async';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TimerPerSec extends StatefulWidget {
  TimerPerSec(this.checkUserAccess, {super.key});

  Function checkUserAccess;

  @override
  State<TimerPerSec> createState() => _TimerPerSecState();
}

class _TimerPerSecState extends State<TimerPerSec> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        widget.checkUserAccess();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
