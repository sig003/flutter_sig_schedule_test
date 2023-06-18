import 'package:flutter/material.dart';
import 'package:sig_schedule_test/screens/schedule_main.dart';

void main() {
  runApp(SigSchedule());
}

class SigSchedule extends StatelessWidget {
  const SigSchedule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScheduleMain(),
    );
  }
}

