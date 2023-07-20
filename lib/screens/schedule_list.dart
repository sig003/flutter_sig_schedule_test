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
  var ListArray = [];
  // final List<Map<String, dynamic>> contents = [
  //   {'title': '약먹기', 'date': '2023-06-10 12:00:00'},
  //   {'title': '쇼핑', 'date': '2023-06-10 12:00:00'},
  //   {'title': '티비', 'date': '2023-06-10 12:00:00'}
  // ];
  //
  // var count = 0;
  //
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _getData();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return ListView.builder(
  //       padding: const EdgeInsets.all(18),
  //       itemCount: count,
  //       itemBuilder: (BuildContext context, int index) {
  //         return Column(
  //           children: [
  //             SizedBox(height: 10,),
  //             Container(
  //               height: 80,
  //               child: Card(
  //                 child: Container(
  //                   //height: 100,
  //                   child: Center(
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Container(
  //                           padding: EdgeInsets.only(left: 10),
  //                           child: Column(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               // Text(contents[index]['title']),
  //                               // SizedBox(height: 10,),
  //                               // Text(contents[index]['date']),
  //                               FutureBuilder(
  //                                   future: _getData(),
  //                                   builder: (BuildContext context, AsyncSnapshot snapshot) {
  //                                     if (snapshot.hasData == false) {
  //                                       return CircularProgressIndicator();
  //                                     }
  //                                     else if (snapshot.hasError) {
  //                                       return Padding(
  //                                         padding: const EdgeInsets.all(8.0),
  //                                         child: Text(
  //                                           'Error: ${snapshot.error}',
  //                                           style: TextStyle(fontSize: 15),
  //                                         ),
  //                                       );
  //                                     }
  //                                     else {
  //                                       return Padding(
  //                                         padding: const EdgeInsets.all(8.0),
  //                                         child: Text(
  //                                           snapshot.data.toString(),
  //                                           style: TextStyle(fontSize: 15),
  //                                         ),
  //                                       );
  //                                     }
  //                                   })
  //                             ],
  //                           ),
  //                         ),
  //                         Container(
  //                           padding: EdgeInsets.only(right: 10),
  //                           child: Icon(
  //                             Icons.delete,
  //                             color: Colors.red,
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   )
  //                 ),
  //               ),
  //             ),
  //           ],
  //         );
  //       }
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getData(),
      builder: (context, snapshot) => ListView.builder(
        itemCount: snapshot.data?.length,
        itemBuilder: (BuildContext context, int index) {
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
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(snapshot.data?[index]['job'] ?? ''),
                                        ),
                                      ],
                                    )
                                ),
                                Container(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
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
        ),
      );
  }

  Future<List<dynamic>> _getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    // setState(() {
    //
    // });
    List<dynamic> bb = prefs.getStringList('data') ?? [];

    for (int i = 0; i < bb.length; i++) {
      ListArray.add(jsonDecode(bb[i]));
    }

    // List<Map<String, String>> aa = [{"id":"c6b63d40-2289-11ee-a39b-9b519e963c49","job":"abcd","date":"2023-07-15","time":"06:03"}];
    // print(aa);

    print(ListArray);
    return ListArray;
  }
}
