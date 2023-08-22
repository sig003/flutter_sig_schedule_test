import 'package:flutter/material.dart';
import 'package:sig_schedule_test/screens/schedule_main.dart';
import 'package:alarm/alarm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init(showDebugLogs: true);
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

