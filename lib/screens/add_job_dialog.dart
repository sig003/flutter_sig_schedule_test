import 'dart:convert';
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
  final _formKey = GlobalKey<FormState>();

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
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  int generateRandomNumberWithDigits(int numDigits) {
    int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    int slicedTime = 0;
    String currentTimeString = currentTimeMillis.toString();

    if (currentTimeString.length >= numDigits) {
      slicedTime = int.parse(currentTimeString.substring(0, numDigits));
    } else {
      slicedTime = int.parse(currentTimeString);
    }
    return slicedTime;
  }

  void _saveJob(String newValue) async {
    if (newValue != '') {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      int randomNumber = generateRandomNumberWithDigits(10);

      Map<String, dynamic> map = {
        'id': randomNumber,
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

      var combinedTime = _combinedDateTime();
      final alarmSettings = AlarmSettings(
        id: randomNumber,
        dateTime: combinedTime,
        assetAudioPath: 'assets/marimba.mp3',
        volumeMax: false,
        notificationTitle: showNotification ? 'Alarm example' : null,
        notificationBody: showNotification ? 'Your alarm is ringing' : null,
        stopOnNotificationOpen: true,
      );
      Alarm.set(alarmSettings: alarmSettings);
    }
  }

  DateTime _combinedDateTime() {
    DateTime combinedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    return combinedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Job'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: jobInput,
              autovalidateMode:AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Job',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: dateInput,
                autovalidateMode:AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Date',
              ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101)
                );

                if (pickedDate != null ) {
                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

                  setState(() {
                    _selectedDate = pickedDate;
                    dateInput.text = formattedDate;
                  });
                } else {
                  print("Date is not selected");
                }
              }
            ),
            TextFormField(
              controller: timeInput,
                autovalidateMode:AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Time',
              ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              readOnly: true,
              onTap: () async {
                _showDialog(
                  CupertinoDatePicker(
                    initialDateTime: DateTime.now(),
                    mode: CupertinoDatePickerMode.time,
                    use24hFormat: true,
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
            if (!_formKey.currentState!.validate()) {
              return;
            }

            _saveJob('aa');
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
