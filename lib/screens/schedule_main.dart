import 'package:flutter/material.dart';
import 'package:sig_schedule_test/screens/schedule_list.dart';
import 'package:sig_schedule_test/screens/add_job_dialog.dart';

class ScheduleMain extends StatefulWidget {
  const ScheduleMain({Key? key}) : super(key: key);

  @override
  State<ScheduleMain> createState() => _ScheduleMainState();
}

class _ScheduleMainState extends State<ScheduleMain> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SigSchedule'),
      ),
      body: ScheduleList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {
          showDialog(context: context, builder: (context) {
            return AddJobDialog();
          }),
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorite',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.delete),
              label: 'Delete'
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}


