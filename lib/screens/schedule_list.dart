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
                  return Column(
                      children: [
                        SizedBox(height: 10,),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ModifyJobDialog(id: resultData?[index]['id'], execSetState: execSetState);
                              },
                            );
                            //ModifyJobDialog(context, resultData?[index]['id'], execSetState);

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
                                                        JobName(jobName: resultData?[index]['job'] ?? 'None'),
                                                        DateAndTimeString(dateString: resultData?[index]['date'] ?? 'None', timeString: resultData?[index]['time'] ?? 'None'),
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
                                                    StopAlarm(resultData?[index]['id']);
                                                    // 원하는 다른 동작을 수행해도 됩니다.
                                                  },
                                                ),
                                              ),
                                              Container(
                                                child: IconButton(
                                                    icon: (resultData?[index]['alarm'] == 'vibrate') ? const Icon(Icons.vibration) : const Icon(Icons.volume_up),
                                                    color: Colors.grey.shade700,
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return ModifyJobDialog(id: resultData?[index]['id'], execSetState: execSetState);
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
                                                      DoneJobDialog(context, resultData?[index]['id'], widget);
                                                    }
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(right: 10),
                                                child: IconButton(
                                                    icon: const Icon(Icons.delete_rounded),
                                                    color: Colors.grey.shade700,
                                                    onPressed: () {
                                                      DeleteJobDialog(context, resultData?[index]['id'], widget);
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
