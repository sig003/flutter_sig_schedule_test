import 'package:flutter/material.dart';
import 'package:sig_schedule_test/screens/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
enum AlarmType { vibrate, volumeUp }

class ModifyJobDialog extends StatefulWidget {
  const ModifyJobDialog({Key? key, required this.id, required this.execSetState}) : super(key: key);

  final int id;
  final Function execSetState;

  @override
  State<ModifyJobDialog> createState() => _ModifyJobDialogState();
}

class _ModifyJobDialogState extends State<ModifyJobDialog> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController jobInput = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  DateTime _selectedTime = DateTime.now();

  AlarmType? _alarmType = AlarmType.vibrate;
  bool _selectedVivrate = true;
  bool _selectedVolumeUp = false;

  Future<void> loadData() async {
    var result = await getSharedPreference(widget.id);

    setState(() {
      jobInput.text = result[0]['job'];
      dateInput.text = result[0]['date'];
      timeInput.text = result[0]['time'];
      _alarmType = (result[0]['alarm'] == 'vibrate') ? AlarmType.vibrate : AlarmType.volumeUp;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
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
                          timeInput.text = formattedTime;
                        }
                        );
                      },
                    ),
                  );
                }
            ),
            Container(
              margin: EdgeInsets.only(
                top: 20.0,
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Alarm Type',
                    style: TextStyle(
                      color: Color.fromARGB(255, 102, 102, 102),
                      fontSize: 13.0,
                    ),
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
                                setState(() {
                                  _alarmType = value;
                                  _selectedVivrate = true;
                                  _selectedVolumeUp = false;
                                });
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
                                setState(() {
                                  _alarmType = value;
                                  _selectedVivrate = false;
                                  _selectedVolumeUp = true;
                                });
                              },
                            ),
                          ),
                        ),
                      ]
                  ),
                ],
              ),
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
            var combinedTime = combinedDateTime(_selectedDate, _selectedTime);
            String showNotification = jobInput.text;

            String selectedAlarmValue = (_alarmType == AlarmType.vibrate) ? 'vibrate' : 'volumeUp';
            modifyJob(widget.id, jobInput, dateInput, timeInput, selectedAlarmValue, combinedTime, showNotification);
            widget.execSetState();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
