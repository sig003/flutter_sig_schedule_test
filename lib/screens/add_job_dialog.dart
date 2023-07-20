import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddJobDialog extends StatefulWidget {
  const AddJobDialog({Key? key}) : super(key: key);

  @override
  State<AddJobDialog> createState() => _AddJobDialogState();
}

class _AddJobDialogState extends State<AddJobDialog> {
  TextEditingController jobInput = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();
  List<String> ListArray = [];

  @override
  void initState() {
    super.initState();
    jobInput.text = '';
    dateInput.text = '';
    timeInput.text = '';
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  void _saveJob(String newValue) async {
    if (newValue != '') {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      var uuid = Uuid();
      var timeBasedId = uuid.v1();

      Map<String, dynamic> map = {
        'id': timeBasedId,
        'job': jobInput.text,
        'date': dateInput.text,
        'time': timeInput.text
      };

      String rawJson = jsonEncode(map);

      List<String> beforeArray = prefs.getStringList('data') ?? [];

      ListArray = [];
      if (beforeArray.length > 0) {
        for (int i = 0; i < beforeArray.length; i += 1) {
          ListArray.add(beforeArray[i]);
        }
      }

      ListArray.add(rawJson);

      prefs.setStringList('data', ListArray);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Job'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: jobInput,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Job',
            ),
          ),
          TextFormField(
            controller: dateInput,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Date',
            ),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101)
              );

              if (pickedDate != null ) {
                print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                print(formattedDate); //formatted date output using intl package =>  2021-03-16
                //you can implement different kind of Date Format here according to your requirement

                setState(() {
                  dateInput.text = formattedDate; //set output date to TextField value.
                });
              } else {
                print("Date is not selected");
              }
            }
          ),
          TextFormField(
            controller: timeInput,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Time',
            ),
            readOnly: true,
            onTap: () async {
              _showDialog(
                CupertinoDatePicker(
                  initialDateTime: DateTime.now(),
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  // This is called when the user changes the time.
                  onDateTimeChanged: (DateTime newTime) {
                    setState(() {
                      String formattedTime = DateFormat('HH:mm').format(newTime);
                      print(formattedTime);
                      timeInput.text = formattedTime;
                    }
                    );
                  },
                ),
              );
            }
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Add'),
          onPressed: () {
            _saveJob('aa');
            Navigator.of(context).pop();
          },
        ),
      ],
    );;
  }
}
