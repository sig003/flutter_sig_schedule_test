import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alarm/alarm.dart';

class AddJobDialog extends StatefulWidget {
  final AlarmSettings? alarmSettings;
  const AddJobDialog({Key? key, this.alarmSettings}) : super(key: key);

  @override
  State<AddJobDialog> createState() => _AddJobDialogState();
}

class _AddJobDialogState extends State<AddJobDialog> {
  TextEditingController jobInput = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();
  List<String> ListArray = [];
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedTime = DateTime.now();

  bool loading = false;
  late bool creating;
  late TimeOfDay selectedTime;
  late bool loopAudio;
  late bool vibrate;
  late bool volumeMax;
  late bool showNotification;
  late String assetAudio;

  @override
  void initState() {
    super.initState();
    jobInput.text = '';
    dateInput.text = '';
    timeInput.text = '';

    creating = widget.alarmSettings == null;
    if (creating) {
      final dt = DateTime.now().add(const Duration(minutes: 1));
      selectedTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
      loopAudio = true;
      vibrate = true;
      volumeMax = true;
      showNotification = true;
      assetAudio = 'assets/marimba.mp3';
    } else {
      selectedTime = TimeOfDay(
        hour: widget.alarmSettings!.dateTime.hour,
        minute: widget.alarmSettings!.dateTime.minute,
      );
      loopAudio = widget.alarmSettings!.loopAudio;
      vibrate = widget.alarmSettings!.vibrate;
      volumeMax = widget.alarmSettings!.volumeMax;
      showNotification = widget.alarmSettings!.notificationTitle != null &&
          widget.alarmSettings!.notificationTitle!.isNotEmpty &&
          widget.alarmSettings!.notificationBody != null &&
          widget.alarmSettings!.notificationBody!.isNotEmpty;
      assetAudio = widget.alarmSettings!.assetAudioPath;
    }
  }
  AlarmSettings buildAlarmSettings() {
    final now = DateTime.now();
    final id = creating
        ? DateTime.now().millisecondsSinceEpoch % 100000
        : widget.alarmSettings!.id;

    DateTime dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      0,
      0,
    );
    if (dateTime.isBefore(DateTime.now())) {
      dateTime = dateTime.add(const Duration(days: 1));
    }

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: dateTime,
      loopAudio: false,
      vibrate: true,
      volumeMax: true,
      notificationTitle: showNotification ? 'Alarm example' : null,
      notificationBody: showNotification ? 'Your alarm ($id) is ringing' : null,
      assetAudioPath: 'assets/marimba.mp3',
      stopOnNotificationOpen: false,
    );
    return alarmSettings;
  }
  void saveAlarm() {
    setState(() => loading = true);
    Alarm.set(alarmSettings: buildAlarmSettings()).then((res) {
      if (res) Navigator.pop(context, true);
    });
    setState(() => loading = false);
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
        'time': timeInput.text,
        'state': 'normal'
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

  void _combinedDateTime() {
    DateTime combinedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
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
                  _selectedDate = pickedDate;
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
                      _selectedTime = newTime;
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
            final alarmSettings = AlarmSettings(
              id: 42,
              dateTime: DateTime.now(),
              assetAudioPath: 'assets/marimba.mp3',
              volumeMax: false,
            );
            Alarm.set(alarmSettings: alarmSettings);
            _saveJob('aa');
            Navigator.of(context).pop();
          },
        ),
      ],
    );;
  }
}
