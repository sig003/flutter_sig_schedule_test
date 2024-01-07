import 'package:flutter/material.dart';
import 'package:sig_schedule_test/screens/done_job_dialog.dart';
import 'package:sig_schedule_test/screens/library.dart';
import 'package:sig_schedule_test/screens/delete_job_dialog.dart';
import 'package:sig_schedule_test/screens/widgets.dart';
import 'package:sig_schedule_test/screens/modify_job_dialog.dart';

class ScheduleList extends StatefulWidget {
  const ScheduleList({Key? key, required this.bottomIndex, required this.setBottomIndex}) : super(key: key);
  final int bottomIndex;
  final Function setBottomIndex;

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  void execSetState() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(widget.bottomIndex),
      builder: (context, snapshot) {
        int dataLength = snapshot.data?.length ?? 0;
        if (dataLength <= 0) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text('Empty')),
            ],
          );
        } else {
          return ListView.builder(
            itemCount: dataLength,
            itemBuilder: (BuildContext context, int index) {
                List<dynamic>? resultData = snapshot.data;

                int jobId = resultData?[index]['id'];
                String jobName = resultData?[index]['job'] ?? 'None';
                String dateString = resultData?[index]['date'] ?? 'None';
                String timeString = resultData?[index]['time'] ?? 'None';
                String alarmType = resultData?[index]['alarm'] ?? 'None';

                  return Column(
                      children: [
                        SizedBox(height: 10,),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ModifyJobDialog(id: jobId, execSetState: execSetState);
                              },
                            );
                            },
                          child: Container(
                            child: Card(
                              child: Container(
                                  child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child:
                                            Container(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        JobName(jobName: jobName),
                                                        DateAndTimeString(dateString: dateString, timeString: timeString),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                child: IconButton(
                                                    icon: const Icon(Icons.clear),
                                                    color: Colors.grey.shade700,
                                                  onPressed: () {
                                                    StopAlarm(jobId);
                                                  },
                                                ),
                                              ),
                                              Container(
                                                child: IconButton(
                                                    icon: (alarmType == 'vibrate') ? const Icon(Icons.vibration) : const Icon(Icons.volume_up),
                                                    color: Colors.grey.shade700,
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return ModifyJobDialog(id: jobId, execSetState: execSetState);
                                                        },
                                                      );
                                                    }
                                                ),
                                              ),
                                              Container(
                                                child: IconButton(
                                                    icon: const Icon(Icons.done_rounded),
                                                    color: Colors.grey.shade700,
                                                    onPressed: () {
                                                      DoneJobDialog(context, jobId, widget);
                                                    }
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(right: 10),
                                                child: IconButton(
                                                    icon: const Icon(Icons.delete_rounded),
                                                    color: Colors.grey.shade700,
                                                    onPressed: () {
                                                      DeleteJobDialog(context, jobId, widget);
                                                    }
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                  )
                              ),
                            ),
                          ),
                        ),
                      ]
                  );
              }
            );
          }
        }
      );
  }
}
