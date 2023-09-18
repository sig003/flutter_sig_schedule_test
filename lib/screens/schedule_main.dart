import 'package:flutter/material.dart';
import 'package:sig_schedule_test/screens/schedule_list.dart';
import 'package:sig_schedule_test/screens/add_job_dialog.dart';
import 'package:sig_schedule_test/screens/bottom_navigation_bar.dart';
import 'package:sig_schedule_test/screens/delete_forever.dart';
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
        child: (bottomIndex == 0) ? Icon(Icons.add) : Icon(Icons.delete_forever) ,
        onPressed: () async {
          if (bottomIndex == 0) {
            await showDialog(context: context, builder: (context) {
              //Vibration.vibrate(duration: 1000);
              return AddJobDialog();
            });
            setState(() {});
          } else {
            _DeleteForever(context);
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavagationBar(setBottomIndex: setBottomIndex),
    );
  }

  Future<void> _DeleteForever(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Basic dialog title'),
          content: const Text(
            'A dialog is a type of modal window that\n'
                'appears in front of app content to\n'
                'provide critical information, or prompt\n'
                'for a decision to be made.',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Disable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Enable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}


