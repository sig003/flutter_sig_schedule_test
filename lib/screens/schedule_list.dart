import 'package:flutter/material.dart';
import 'package:sig_schedule_test/screens/done_job_dialog.dart';
import 'package:sig_schedule_test/screens/library.dart';
import 'package:sig_schedule_test/screens/delete_job_dialog.dart';
import 'package:sig_schedule_test/screens/widgets.dart';
import 'package:sig_schedule_test/screens/done_job_dialog.dart';

class ScheduleList extends StatefulWidget {
  const ScheduleList({Key? key, required this.bottomIndex, required this.setBottomIndex}) : super(key: key);
  final int bottomIndex;
  final Function setBottomIndex;

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
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
                        Container(
                          height: 80,
                          child: Card(
                            child: Container(
                                child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    JobName(jobName: resultData?[index]['job'] ?? 'None'),
                                                    DateAndTimeString(dateString: resultData?[index]['date'] ?? 'None', timeString: resultData?[index]['time'] ?? 'None'),
                                                  ],
                                                ),
                                              ],
                                            )
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              child: IconButton(
                                                  icon: const Icon(Icons.done_rounded),
                                                  color: Colors.green,
                                                  onPressed: () {
                                                    DoneJobDialog(context, resultData?[index]['id']);
                                                  }
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(right: 10),
                                              child: IconButton(
                                                  icon: const Icon(Icons.delete_rounded),
                                                  color: Colors.red,
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
                      ]
                  );
              }
            );
          }
        }
      );
  }
}
