import 'package:flutter/material.dart';
import 'package:sig_schedule_test/screens/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
enum AlarmType { vibrate, volumeUp }

Future<void> ModifyJobDialog(BuildContext context, id, execSetState) async {
  final _formKey = GlobalKey<FormState>();

  TextEditingController jobInput = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedTime = DateTime.now();

  AlarmType? _alarmType = AlarmType.vibrate;
  bool _selectedVivrate = true;
  bool _selectedVolumeUp = false;

  var result = await getSharedPreference(id);

  jobInput.text = result[0]['job'];
  dateInput.text = result[0]['date'];
  timeInput.text = result[0]['time'];
  _alarmType = ( result[0]['alarm'] == 'vibrate' ) ? AlarmType.vibrate : AlarmType.volumeUp;

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

  if (!context.mounted) return;

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Modify Job'),
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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

                      _selectedDate = pickedDate;
                      dateInput.text = formattedDate;
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
                          //setState(() {
                            _selectedTime = newTime;
                            String formattedTime = DateFormat('HH:mm').format(newTime);
                            timeInput.text = formattedTime;
                          //});
                        },
                      ),
                    );
                  }
              ),
              SizedBox(height: 20.0),
              Row(
                  children: <Widget>[
                    Expanded(
                      // Icon(Icons.vibration, color: Colors.blue),
                      // SizedBox(width: 50.0),
                      // Icon(Icons.volume_up),
                      child: ListTile(
                        trailing: Icon(
                            Icons.vibration,
                            size: 35.0,
                            color: (_selectedVivrate) ? Colors.blue : null),
                        title: null,
                        leading: Radio<AlarmType>(
                          value: AlarmType.vibrate,
                          groupValue: _alarmType,
                          onChanged: (AlarmType? value) {
                              _alarmType = value;
                              _selectedVivrate = true;
                              _selectedVolumeUp = false;
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        trailing: Icon(
                          Icons.volume_up,
                          size: 35.0,
                          color: (_selectedVolumeUp) ? Colors.blue : null,
                        ),
                        title: null,
                        leading: Radio<AlarmType>(
                          value: AlarmType.volumeUp,
                          groupValue: _alarmType,
                          onChanged: (AlarmType? value) {
                              _alarmType = value;
                              _selectedVivrate = false;
                              _selectedVolumeUp = true;
                          },
                        ),
                      ),
                    ),
                  ]
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              }
          ),
          TextButton(
              child: const Text('Modify'),
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  return;
                }
                var showNotification = jobInput.text;
                var combinedTime = combinedDateTime(_selectedDate, _selectedTime);

                String selectedAlarmValue = (_alarmType == AlarmType.vibrate) ? 'vibrate' : 'volumeUp';
                modifyJob(id, jobInput, dateInput, timeInput, selectedAlarmValue, combinedTime, showNotification);
                execSetState();
                Navigator.pop(context);
              }
          ),
        ],
      );
    }
  );
}