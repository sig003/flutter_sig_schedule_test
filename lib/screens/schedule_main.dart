import 'package:flutter/material.dart';

class ScheduleMain extends StatelessWidget {
  const ScheduleMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SigSchedule'),
      ),
      body: Center(
        child: Text('Starting...'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {
          print('click')
        },
      ),
    );
  }
}
