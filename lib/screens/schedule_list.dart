import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleList extends StatefulWidget {
  const ScheduleList({Key? key}) : super(key: key);

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  final List<Map<String, dynamic>> contents = [
    {'title': '약먹기', 'date': '2023-06-10 12:00:00'},
    {'title': '쇼핑', 'date': '2023-06-10 12:00:00'},
    {'title': '티비', 'date': '2023-06-10 12:00:00'}
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: contents.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              SizedBox(height: 10,),
              Container(
                height: 80,
                child: Card(
                  child: Container(
                    //height: 100,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Text(contents[index]['title']),
                                // SizedBox(height: 10,),
                                // Text(contents[index]['date']),
                                FutureBuilder(
                                    future: _getData(),
                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                      if (snapshot.hasData == false) {
                                        return CircularProgressIndicator();
                                      }
                                      else if (snapshot.hasError) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Error: ${snapshot.error}',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        );
                                      }
                                      else {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            snapshot.data.toString(),
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        );
                                      }
                                    })
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    )
                  ),
                ),
              ),
            ],
          );
        }
    );
  }

  Future<String> _getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? job = prefs.getString('job') ?? '';

    return job;
  }
}
