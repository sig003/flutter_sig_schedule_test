import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:alarm/alarm.dart';
import 'package:sig_schedule_test/screens/library.dart';

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
            saveJob(jobInput, dateInput, timeInput, combinedTime, showNotification);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
