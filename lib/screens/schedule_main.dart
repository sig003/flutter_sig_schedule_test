import 'package:flutter/material.dart';
import 'package:sig_schedule_test/screens/schedule_list.dart';
import 'package:sig_schedule_test/screens/add_job_dialog.dart';
import 'package:sig_schedule_test/screens/bottom_navigation_bar.dart';
import 'package:sig_schedule_test/screens/delete_forever.dart';

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
      body: ScheduleList(bottomIndex: bottomIndex, setBottomIndex: setBottomIndex),
      floatingActionButton: FloatingActionButton(
        child: (bottomIndex == 0) ? Icon(Icons.add) : Icon(Icons.delete_forever) ,
        onPressed: () async {
          if (bottomIndex == 0) {
            await showDialog(context: context, builder: (context) {
              return AddJobDialog();
            });
            setState(() {});
          } else {
            DeleteForever(context, setBottomIndex);
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavagationBar(setBottomIndex: setBottomIndex),
    );
  }
}


