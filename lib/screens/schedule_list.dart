import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ScheduleList extends StatefulWidget {
  const ScheduleList({Key? key}) : super(key: key);

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class Job {
  String id;
  String job;
  String date;
  String time;

  Job(this.id, this.job, this.date, this.time);

  Map toJson() => {
    'id': id,
    'job': job,
    'date': date,
    'time': time,
  };
}

class _ScheduleListState extends State<ScheduleList> {
  //var ListArray = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getData(),
      builder: (context, snapshot) {
        var aa = snapshot.data?.length ?? 0;
        if (aa > 0) {
          return Text('Has Data');
        }
        return Text('No data');
          // if (snapshot.hasData) {
          //   return ListView.builder(
          //     itemCount: snapshot.data?.length,
          //     itemBuilder: (BuildContext context, int index) {
          //         List<dynamic>? resultData = snapshot.data;
          //           return Column(
          //               children: [
          //                 SizedBox(height: 10,),
          //                 Container(
          //                   height: 80,
          //                   child: Card(
          //                     child: Container(
          //                         child: Center(
          //                             child: Row(
          //                               mainAxisAlignment: MainAxisAlignment
          //                                   .spaceBetween,
          //                               children: [
          //                                 Container(
          //                                     padding: EdgeInsets.only(left: 10),
          //                                     child: Column(
          //                                       mainAxisAlignment: MainAxisAlignment
          //                                           .center,
          //                                       children: [
          //                                         Column(
          //                                           crossAxisAlignment: CrossAxisAlignment
          //                                               .start,
          //                                           children: [
          //                                             Padding(
          //                                               padding: const EdgeInsets
          //                                                   .fromLTRB(8, 5, 0, 5),
          //                                               child: Text(
          //                                                   resultData?[index]['job'] ??
          //                                                       'None',
          //                                                   style: TextStyle(
          //                                                       fontSize: 17,
          //                                                       fontWeight: FontWeight
          //                                                           .bold)),
          //                                             ),
          //                                             Row(
          //                                               children: [
          //                                                 Padding(
          //                                                   padding: const EdgeInsets
          //                                                       .all(8.0),
          //                                                   child: Text(
          //                                                       resultData?[index]['date'] ??
          //                                                           'None'),
          //                                                 ),
          //                                                 Padding(
          //                                                   padding: const EdgeInsets
          //                                                       .all(8.0),
          //                                                   child: Text(
          //                                                       resultData?[index]['time'] ??
          //                                                           'None'),
          //                                                 ),
          //                                               ],
          //                                             ),
          //                                           ],
          //                                         ),
          //                                       ],
          //                                     )
          //                                 ),
          //                                 Container(
          //                                   padding: EdgeInsets.only(right: 10),
          //                                   child: Icon(
          //                                     Icons.delete,
          //                                     color: Colors.red,
          //                                   ),
          //                                 ),
          //                               ],
          //                             )
          //                         )
          //                     ),
          //                   ),
          //                 ),
          //               ]
          //           );
          //       }
          //     );
          //   } else {
          //   return Text('No Data');
          // }
        }
      );
  }

  Future<List<dynamic>> _getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> jsonData = prefs.getStringList('data') ?? [];

    var ListArray = [];
    for (int i = 0; i < jsonData.length; i++) {
      ListArray.add(jsonDecode(jsonData[i]));
    }

    List<dynamic> reverserdListArray = List.from(ListArray.reversed);
    // setState(() {
    //
    // });
    return reverserdListArray;
  }
}
