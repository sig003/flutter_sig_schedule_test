import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ScheduleList extends StatefulWidget {
  const ScheduleList({Key? key}) : super(key: key);

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getData(),
      builder: (context, snapshot) {
        int dataLength = snapshot.data?.length ?? 0;
        if (dataLength <= 0) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text('No Data')),
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
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(8, 5, 0, 5),
                                                      child: Text(
                                                          resultData?[index]['job'] ??
                                                              'None',
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight: FontWeight
                                                                  .bold)),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .all(8.0),
                                                          child: Text(
                                                              resultData?[index]['date'] ??
                                                                  'None'),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .all(8.0),
                                                          child: Text(
                                                              resultData?[index]['time'] ??
                                                                  'None'),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(right: 10),
                                          child: IconButton(
                                            icon: const Icon(Icons.delete),
                                            color: Colors.red,
                                            onPressed: () {
                                              _delData(resultData?[index]['id'] ??
                                                  'None');
                                            },
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
            );
          }
        }
      );
  }

  Future<List<dynamic>> _getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> jsonData = prefs.getStringList('data') ?? [];

    var ListArray = [];

    for (int i = 0; i < jsonData.length; i++) {
      if (jsonDecode(jsonData[i])['state'] == 'normal') {
        ListArray.add(jsonDecode(jsonData[i]));
      }
    }

    List<dynamic> reverserdListArray = List.from(ListArray.reversed);
    // setState(() {
    //
    // });
    return reverserdListArray;
  }

   void _delData(id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> jsonData = prefs.getStringList('data') ?? [];

    List<String> ListArray = [];

    if (jsonData.length > 0) {
      for (int i = 0; i < jsonData.length; i++) {
        if (jsonDecode(jsonData[i])['id'] == id) {
          Map<String, dynamic> map = {
            'id': jsonDecode(jsonData[i])['id'],
            'job': jsonDecode(jsonData[i])['job'],
            'date': jsonDecode(jsonData[i])['date'],
            'time': jsonDecode(jsonData[i])['time'],
            'state': 'delete'
          };
          String rawJson = jsonEncode(map);
          ListArray.add(rawJson);
        } else {
          ListArray.add(jsonData[i]);
        }
      }
      prefs.setStringList('data', ListArray);
    }
  }
}
