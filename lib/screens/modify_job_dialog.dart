import 'package:flutter/material.dart';
import 'package:sig_schedule_test/screens/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

Future<void> ModifyJobDialog(BuildContext context, id) async {
  final _formKey = GlobalKey<FormState>();

  TextEditingController jobInput = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedTime = DateTime.now();

  var result = await getSharedPreference(id);

  jobInput.text = result[0]['job'];
  dateInput.text = result[0]['date'];
  timeInput.text = result[0]['time'];

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
                var showNotification = true;
                var combinedTime = combinedDateTime(_selectedDate, _selectedTime);
                modifyJob(id, jobInput, dateInput, timeInput, combinedTime, showNotification);
                Navigator.pop(context);
              }
          ),
        ],
      );
    }
  );
}