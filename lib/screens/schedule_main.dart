import 'package:flutter/material.dart';
import 'package:sig_schedule_test/screens/schedule_list.dart';
import 'package:sig_schedule_test/screens/add_job_dialog.dart';
import 'package:sig_schedule_test/screens/bottom_navigation_bar.dart';
//import 'package:vibration/vibration.dart';

class ScheduleMain extends StatefulWidget {
  const ScheduleMain({Key? key}) : super(key: key);

  @override
  State<ScheduleMain> createState() => _ScheduleMainState();
}

class _ScheduleMainState extends State<ScheduleMain> {
  int bottomIndex = 0;
  setBottomIndex(int index) {
    setState(() {
      bottomIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('SigSchedule'),
      ),
      body: ScheduleList(bottomIndex: bottomIndex),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await showDialog(context: context, builder: (context) {
            //Vibration.vibrate(duration: 1000);
            return AddJobDialog();
          });
          setState(() {});
        },
      ),
      bottomNavigationBar: CustomBottomNavagationBar(setBottomIndex: setBottomIndex),
    );
  }
}


